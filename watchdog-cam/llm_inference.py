# llm_inference.py
import os
import json
from GeminiClient import transcribe  # Import transcribe from your Gemini client file

# Function to run LLM inference on a video file
def llm_inference(video_file_path):
    try:
        print(f"Uploading file {video_file_path} to Gemini AI for transcription...")
        response_text = transcribe(video_file_path)

        # Print the raw response for debugging purposes
        print(f"Raw LLM Response: {response_text}")  # Debugging print statement

        # Clean up response_text to handle cases like triple backticks or unexpected formatting
        cleaned_response = response_text.strip().strip('```').strip('json').strip()  # Remove backticks, 'json' keyword, and extra spaces
        print(f"Cleaned LLM Response: {cleaned_response}")  # Debugging print statement

        # Parse the cleaned_response using json.loads for better error handling
        try:
            response_data = json.loads(cleaned_response)  # Convert cleaned response string to a dictionary
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON response for {video_file_path}: {e}")
            return None

        # Prepare the data to be uploaded to Firebase
        llm_data = {
            "description": response_data.get("description", "No description provided"),
            "threat_level": bool(int(response_data.get("Threat level", "0"))),
            "offset": response_data.get("offset", 0)
        }
        return llm_data
    except Exception as e:
        print(f"Error during LLM inference for {video_file_path}: {e}")
        return None
