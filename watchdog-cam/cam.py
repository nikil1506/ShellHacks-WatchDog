# main.py

import subprocess
import threading
import time
import os
from firebase_admin import credentials, firestore, storage
import firebase_admin
import google.generativeai as genai
from datetime import datetime

# Firebase initialization
cred = credentials.Certificate("watchdog-camera-firebase-adminsdk-md8le-0798f0eb1c.json")
firebase_admin.initialize_app(cred, {
    'storageBucket': 'watchdog-camera.appspot.com'  # Updated with correct bucket name
})

# Firestore and Storage references
db = firestore.client()
bucket = storage.bucket()

# Configure Generative AI API
genai.configure(api_key=os.environ.get("GEMINI_API_KEY"))

# Directory and files for video processing
save_dir = 'Saved'
log_file = 'event_log.txt'
video_list_file = 'new_videos.txt'

# Function to monitor new video files for upload and LLM inference
def monitor_and_process():
    while True:
        if os.path.exists(video_list_file):
            with open(video_list_file, "r") as file:
                video_files = file.readlines()
            
            if video_files:
                for video_file in video_files:
                    video_file = video_file.strip()
                    if video_file:
                        # Upload and process each video
                        upload_and_process(video_file)

                # Clear the file after processing
                with open(video_list_file, "w") as file:
                    pass
        time.sleep(5)

# Function to upload and process video
def upload_and_process(video_file_path):
    try:
        # Upload video to Firebase Storage
        video_url = upload_to_storage(video_file_path, f"videos/{os.path.basename(video_file_path)}")

        if video_url:
            log_event(f"Video uploaded to Firebase: {video_file_path}")
            
            # LLM inference
            print(f"Making LLM inference request for {video_file_path}...")
            response_text = transcribe(video_file_path)
            
            # Save metadata to Firestore
            metadata = {
                "video_url": video_url,
                "response": response_text,
                "uploaded_at": firestore.SERVER_TIMESTAMP
            }
            save_to_firestore("video_logs", os.path.basename(video_file_path), metadata)
        else:
            print(f"Upload failed for {video_file_path}")
    except Exception as e:
        print(f"Error processing {video_file_path}: {e}")

# Function to upload file to Firebase Storage
def upload_to_storage(local_file_path, storage_path):
    try:
        blob = bucket.blob(storage_path)
        blob.upload_from_filename(local_file_path)
        blob.make_public()
        print(f"File uploaded to {blob.public_url}")
        return blob.public_url
    except Exception as e:
        print(f"Failed to upload {local_file_path} to Firebase Storage: {e}")
        return None

# Function to save metadata to Firestore
def save_to_firestore(collection_name, document_name, data):
    try:
        doc_ref = db.collection(collection_name).document(document_name)
        doc_ref.set(data)
        print(f"Data saved to Firestore in {collection_name}/{document_name}.")
    except Exception as e:
        print(f"Failed to save data to Firestore: {e}")

# Function to transcribe video using Gemini AI
def transcribe(video_file_path):
    print(f"Uploading file {video_file_path} to Gemini AI...")
    video_file = genai.upload_file(path=video_file_path)
    while video_file.state.name == "PROCESSING":
        print('Waiting for video to be processed.')
        time.sleep(10)
        video_file = genai.get_file(video_file.name)

    if video_file.state.name == "FAILED":
        raise ValueError(video_file.state.name)
    print(f'Video processing complete: ' + video_file.uri)

    # Create the prompt.
    prompt = (
        "You are an expert video analyst. Provide a concise and clear description of the content, focusing on key events and details. "
        "Specifically, look out for any kind of dangerous activities and describe them. Dangerous activities include any situations of harm, theft, or assault. "
        "Use NLP techniques to describe the situation as accurately as possible. "
        "In case of a threat event, a flag called 'Threat level' must be set as 1; otherwise, the 'Threat level' flag is 0. "
        "In case of a threat event, an 'offset' value must also be set, representing the time in seconds after the start of the video when the threat event occurs. "
        "If there is no threat event, the description can be along the lines of 'Nothing of interest happens in this segment.' "
        "You are to strictly follow the output format shown below:\n"
        """
        {
            "Threat level": "<0/1>",
            "description": "<A description of the event>",
            "offset": <xx>
        }
        """
    )

    # Set the model to Gemini 1.5 Flash.
    model = genai.GenerativeModel(model_name="models/gemini-1.5-flash")

    # Make the LLM request.
    print("Making LLM inference request...")
    response = model.generate_content([prompt, video_file], request_options={"timeout": 600})
    return response.text

# Function to log events to a file
def log_event(message):
    with open(log_file, 'a') as f:
        f.write(f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {message}\n")

# Function to start the video capture process in a separate thread
def start_video_capture():
    subprocess.Popen(["python", "video_capture.py"])

# Start video capture and monitoring in parallel threads
if __name__ == "__main__":
    # Start video capture in a separate thread
    capture_thread = threading.Thread(target=start_video_capture)
    capture_thread.start()

    # Start monitoring and processing in the main thread
    monitor_and_process()
