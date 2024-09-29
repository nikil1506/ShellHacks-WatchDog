# video_capture.py
import cv2
import collections
import os
from datetime import datetime

# Video and logging variables
fps = 15  # Frames per second for video capture
buffer_duration = 20  # Buffer duration in seconds
max_frames = buffer_duration * fps  # Maximum number of frames in the buffer
save_dir = 'Saved'  # Directory to save video files
exit_signal_file = 'exit_signal.txt'  # File to signal for exit

# Ensure save directory exists
if not os.path.exists(save_dir):
    os.makedirs(save_dir)

# Initialize camera and buffer
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)  # Use DirectShow as fallback
frame_width = int(cap.get(3))
frame_height = int(cap.get(4))
frame_buffer = collections.deque(maxlen=max_frames)  # Circular buffer for frames

def save_video_from_buffer(output_filename):
    """
    Saves the video frames from the buffer to a file.

    Args:
        output_filename (str): The path to save the video file.
    """
    out = cv2.VideoWriter(output_filename, cv2.VideoWriter_fourcc(*'avc1'), fps, (frame_width, frame_height))
    
    for frame in frame_buffer:
        out.write(frame)
    
    out.release()
    print(f"Video saved to '{output_filename}'.")

def main():
    try:
        while True:
            # Capture frames and store them in the buffer
            ret, frame = cap.read()
            if not ret:
                print("Failed to grab frame.")
                break
            
            frame_buffer.append(frame)
            cv2.imshow('Live Video', frame)

            # Check if the buffer is full (1 minute has passed)
            if len(frame_buffer) == max_frames:
                timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
                video_filename = os.path.join(save_dir, f"VID_{timestamp}.mp4")

                # Save the video from the buffer
                save_video_from_buffer(video_filename)

                # Notify main script about the new video file
                with open("new_videos.txt", "a") as f:
                    f.write(video_filename + "\n")

                # Clear the buffer for the next cycle
                frame_buffer.clear()
            
            # Check if 'q' is pressed to save video and continue recording
            if cv2.waitKey(1) & 0xFF == ord('q'):
                timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
                video_filename = os.path.join(save_dir, f"VID_{timestamp}.mp4")

                # Save the video from the buffer
                save_video_from_buffer(video_filename)

                # Notify main script about the new video file
                with open("new_videos.txt", "a") as f:
                    f.write(video_filename + "\n")
                
                print("Recording continues. Press 'q' again to save and continue.")

            # Check if 'c' is pressed to trigger graceful exit
            if cv2.waitKey(1) & 0xFF == ord('c'):
                print("Exit signal detected. Stopping recording and closing gracefully...")
                # Create exit signal file to notify main script
                with open(exit_signal_file, "w") as f:
                    f.write("exit")
                break
            
    except KeyboardInterrupt:
        print("Manual interruption detected. Exiting gracefully...")
    finally:
        # Release resources
        cap.release()
        cv2.destroyAllWindows()
        print("Camera released and application closed.")

# Run the main function
if __name__ == '__main__':
    main()
