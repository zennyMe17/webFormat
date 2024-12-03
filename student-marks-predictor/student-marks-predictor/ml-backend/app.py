# ml-backend/app.py
from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

# Load pre-trained model
model = joblib.load('marks_predictor.pkl')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()  # Get JSON data from the request
    hours = data.get('hours')

    if not hours:
        return jsonify({'error': 'No hours provided'}), 400
    
    # Make prediction using the loaded model
    predicted_marks = model.predict(np.array([[hours]]))

    return jsonify({'predictedMarks': predicted_marks[0]})


if __name__ == '__main__':
    app.run(port=5001)  # Flask runs on port 5001
