# main.py
import threading
import subprocess
import queue
import time
import os
from firebase_upload import upload_to_firebase
from llm_inference import llm_inference

# Queues for LLM inference and Firebase uploads
llm_queue = queue.Queue()
upload_queue = queue.Queue()
exit_signal_file = 'exit_signal.txt'  # File to signal for exit

# Start the video capture process in a separate thread
def start_video_capture():
    subprocess.Popen(["python", "video_capture.py"])

# Worker function for LLM inference
def llm_worker():
    while True:
        video_file = llm_queue.get()
        if video_file is None:
            break

        print(f"Running LLM inference for {video_file}...")  # Debugging print statement
        llm_response = llm_inference(video_file)
        
        # Print LLM response for debugging
        print(f"LLM response for {video_file}: {llm_response}")  # Debugging print statement

        # Check if LLM response is valid
        if llm_response is not None:
            # Put the result in the upload queue
            upload_queue.put((video_file, llm_response))
        else:
            print(f"Skipping Firebase upload for {video_file} due to invalid LLM response.")
        
        llm_queue.task_done()

# Worker function for Firebase uploads
def upload_worker():
    while True:
        video_file, llm_response = upload_queue.get()
        if video_file is None:
            break

        # Step 2: Trigger Firebase upload
        print(f"Uploading {video_file} to Firebase...")  # Debugging print statement
        upload_to_firebase(video_file, llm_response)
        upload_queue.task_done()

# Function to monitor new videos and add them to the LLM queue
def monitor_videos():
    while not os.path.exists(exit_signal_file):  # Monitor until exit signal is detected
        if os.path.exists("new_videos.txt"):
            with open("new_videos.txt", "r") as file:
                video_files = file.readlines()

            for video_file in video_files:
                video_file = video_file.strip()
                if video_file:
                    # Print video file being added to the LLM queue for debugging
                    print(f"Adding {video_file} to LLM queue.")  # Debugging print statement
                    # Add each video file to the LLM queue
                    llm_queue.put(video_file)
            
            # Clear the file after processing
            with open("new_videos.txt", "w") as file:
                pass
        
        time.sleep(5)  # Check every 5 seconds for new videos

def main():
    # Start video capture in a separate thread
    capture_thread = threading.Thread(target=start_video_capture)
    capture_thread.start()

    # Start worker threads for LLM inference and Firebase upload
    llm_thread = threading.Thread(target=llm_worker)
    upload_thread = threading.Thread(target=upload_worker)
    llm_thread.start()
    upload_thread.start()

    # Start monitoring and processing videos
    monitor_videos()

    # Wait for the LLM queue to be empty before exiting
    llm_queue.join()
    upload_queue.join()

    # Signal the worker threads to exit
    llm_queue.put(None)
    upload_queue.put(None)
    llm_thread.join()
    upload_thread.join()

    # Clean up exit signal file
    if os.path.exists(exit_signal_file):
        os.remove(exit_signal_file)
    print("Graceful exit completed. Program stopped.")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Manual interruption detected. Exiting gracefully...")
