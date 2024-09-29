# firebase_upload.py
import firebase_admin
from firebase_admin import credentials, firestore, storage
import os
from datetime import datetime
import time
import requests

# Firebase initialization
cred = credentials.Certificate("watchdog-camera-firebase-adminsdk-md8le-0798f0eb1c.json")
firebase_admin.initialize_app(cred, {
    'storageBucket': 'watchdog-camera.appspot.com'  # Correct bucket name
})

# Firestore and Storage references
db = firestore.client()
bucket = storage.bucket()

# Constants for retry mechanism
MAX_RETRIES = 3
RETRY_DELAY = 5  # Seconds

# Get location based on IP address
def get_location():
    try:
        response = requests.get("https://ipinfo.io/")
        data = response.json()
        loc = data['loc'].split(',')
        latitude = loc[0]
        longitude = loc[1]
        return latitude, longitude
    except Exception as e:
        print(f"Error getting location: {e}")
        return None, None

# Get address from latitude and longitude using OpenStreetMap's Nominatim API
def get_address(latitude, longitude):
    try:
        url = f"https://nominatim.openstreetmap.org/reverse?format=json&lat={latitude}&lon={longitude}&zoom=18&addressdetails=1"
        response = requests.get(url)
        data = response.json()
        if 'error' not in data:
            address = data.get('display_name')
            return address
        else:
            return "Address not found"
    except Exception as e:
        print(f"Error getting address: {e}")
        return None

# Function to upload file to Firebase Storage with retry mechanism
def upload_to_storage(local_file_path, storage_path):
    attempts = 0
    while attempts < MAX_RETRIES:
        try:
            # Verify the file exists before uploading
            if not os.path.exists(local_file_path):
                print(f"File {local_file_path} does not exist. Skipping upload.")
                return None

            blob = bucket.blob(storage_path)
            blob.upload_from_filename(local_file_path)
            blob.make_public()  # Make the file public
            print(f"File uploaded to {blob.public_url}")
            return blob.public_url
        except Exception as e:
            attempts += 1
            print(f"Failed to upload {local_file_path} to Firebase Storage: {e}")
            if attempts < MAX_RETRIES:
                print(f"Retrying in {RETRY_DELAY} seconds... (Attempt {attempts}/{MAX_RETRIES})")
                time.sleep(RETRY_DELAY)
            else:
                print(f"Max retries reached. Skipping {local_file_path}.")
                return None

# Function to save metadata to Firestore with retry mechanism
def save_to_firestore(collection_name, document_name, data):
    attempts = 0
    while attempts < MAX_RETRIES:
        try:
            print(f"Saving to Firestore in {collection_name}/{document_name} with data: {data}")  # Debugging print statement
            doc_ref = db.collection(collection_name).document(document_name)
            doc_ref.set(data)
            print(f"Data saved to Firestore in {collection_name}/{document_name}.")
            return True
        except Exception as e:
            attempts += 1
            print(f"Failed to save data to Firestore: {e}")
            if attempts < MAX_RETRIES:
                print(f"Retrying in {RETRY_DELAY} seconds... (Attempt {attempts}/{MAX_RETRIES})")
                time.sleep(RETRY_DELAY)
            else:
                print(f"Max retries reached. Skipping saving data for {document_name}.")
                return False

# Function to handle upload to Firebase with LLM data and location data
def upload_to_firebase(video_file_path, llm_data):
    try:
        # Check if llm_data is None
        if llm_data is None:
            print(f"Skipping Firebase upload for {video_file_path} due to invalid LLM data.")
            return

        # Step 1: Upload video to Firebase Storage
        print(f"Uploading video {video_file_path} to Firebase Storage...")  # Debugging print statement
        video_url = upload_to_storage(video_file_path, f"videos/{os.path.basename(video_file_path)}")

        if video_url:
            # Get location and address
            latitude, longitude = get_location()
            if latitude and longitude:
                address = get_address(latitude, longitude)
            else:
                address = "Location not available"

            # Step 2: Prepare metadata with PC timestamp, LLM data, and location data
            metadata = {
                "video_url": video_url,
                "description": llm_data.get("description"),
                "threat_level": llm_data.get("threat_level"),
                "offset": llm_data.get("offset"),
                "timestamp": datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ"),  # PC timestamp
                "latitude": latitude,
                "longitude": longitude,
                "address": address,
                "number_of_people": llm_data.get("number_of_people"),
                "attire": llm_data.get("attire"),
                "recognizable_features": llm_data.get("recognizable_features"),
                "object_of_interest": llm_data.get("object_of_interest")
            }

            print(f"Uploading metadata to Firestore: {metadata}")  # Debugging print statement

            # Step 3: Save metadata to Firestore
            if not save_to_firestore("cam0", os.path.basename(video_file_path), metadata):
                print(f"Failed to save metadata for {video_file_path}.")
        else:
            print(f"Failed to upload video {video_file_path}. Metadata not saved.")
    except Exception as e:
        print(f"Error uploading {video_file_path} to Firebase: {e}")
