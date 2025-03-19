
# import cv2
# from simple_facerec import SimpleFacerec

# # Encode faces from folder
# sfr = SimpleFacerec()
# sfr.load_encoding_images("images/")

# # Load Camera
# cap = cv2.VideoCapture(0)

# while True:
#     ret, frame = cap.read()
#     if not ret:
#         break  # Exit loop if the frame is not captured properly

#     # Detect Faces
#     face_locations, face_names = sfr.detect_known_faces(frame)
#     for face_loc, name in zip(face_locations, face_names):
#         y1, x2, y2, x1 = face_loc
#         cv2.putText(frame, name, (x1, y1 - 10), cv2.FONT_HERSHEY_DUPLEX, 1, (0, 0, 200), 2)
#         cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 0, 200), 4)

#     cv2.imshow("Frame", frame)

#     # Exit if 'ESC' key is pressed or window is closed
#     if cv2.waitKey(1) == 27 or cv2.getWindowProperty("Frame", cv2.WND_PROP_VISIBLE) < 1:
#         break

# cap.release()
# cv2.destroyAllWindows()
from flask import Flask, Response
import cv2
from simple_facerec import SimpleFacerec
import os
port = int(os.environ.get("PORT", 5000))
app = Flask(__name__)

# Load Face Recognition model
sfr = SimpleFacerec()
sfr.load_encoding_images("images/")

cap = cv2.VideoCapture(0)  # Open webcam

def generate_frames():
    while True:
        success, frame = cap.read()
        if not success:
            break

        face_locations, face_names = sfr.detect_known_faces(frame)
        for (y1, x2, y2, x1), name in zip(face_locations, face_names):
            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 3)
            cv2.putText(frame, name, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)

        _, buffer = cv2.imencode('.jpg', frame)
        frame = buffer.tobytes()

        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

@app.route('/')
def index():
    return "<h1>Face Recognition App</h1><img src='/video_feed'>"

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port, debug=True)
