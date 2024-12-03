#!/bin/bash

# Create the main project directory
mkdir -p student-marks-predictor

# Navigate into the project directory
cd student-marks-predictor

# Create subdirectories
echo "Creating directory structure..."
mkdir -p backend/routes
mkdir -p ml-backend
mkdir -p frontend/src/components
mkdir -p frontend/src/services
mkdir -p frontend/public

# Create files for ml-backend
echo "Creating Flask backend files..."
cat > ml-backend/app.py <<EOL
from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

# Load the trained model
model = joblib.load('marks_predictor.pkl')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    hours = data.get('hours')
    
    if hours is None or not isinstance(hours, (int, float)):
        return jsonify({'error': 'Invalid input. Please provide a number for hours.'}), 400
    
    # Make prediction
    prediction = model.predict(np.array([[hours]]))[0]
    return jsonify({'predictedMarks': prediction})

if __name__ == '__main__':
    app.run(debug=True, port=5001)
EOL

cat > ml-backend/requirements.txt <<EOL
Flask==2.3.0
numpy==1.21.0
scikit-learn==1.0
joblib==1.1.0
EOL

# Placeholder for marks_predictor.pkl
touch ml-backend/marks_predictor.pkl

# Create files for backend
echo "Creating Node.js backend files..."
cat > backend/server.js <<EOL
const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(bodyParser.json());

app.post('/predict', async (req, res) => {
    const { hours } = req.body;

    if (!hours || isNaN(hours)) {
        return res.status(400).json({ error: "Invalid input: Hours must be a number" });
    }

    try {
        // Forward request to Flask backend
        const flaskResponse = await axios.post('http://localhost:5001/predict', { hours });
        res.json(flaskResponse.data);
    } catch (error) {
        console.error("Error calling Flask backend:", error.message);
        res.status(500).json({ error: "Error communicating with the ML service" });
    }
});

app.listen(5000, () => {
    console.log("Node.js backend running on port 5000");
});
EOL

cat > backend/package.json <<EOL
{
  "name": "student-marks-predictor-backend",
  "version": "1.0.0",
  "description": "Node.js backend for the student marks predictor",
  "main": "server.js",
  "dependencies": {
    "axios": "^1.4.0",
    "body-parser": "^1.20.2",
    "cors": "^2.8.5",
    "express": "^4.18.2"
  }
}
EOL

# Create files for frontend
echo "Creating React frontend files..."
cat > frontend/src/index.js <<EOL
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(<App />, document.getElementById('root'));
EOL

cat > frontend/src/App.js <<EOL
import React from "react";
import PredictForm from "./components/PredictForm";

function App() {
    return (
        <div className="App">
            <PredictForm />
        </div>
    );
}

export default App;
EOL

cat > frontend/src/components/PredictForm.js <<EOL
import React, { useState } from "react";
import axios from "../services/api";

const PredictForm = () => {
    const [hours, setHours] = useState("");
    const [prediction, setPrediction] = useState(null);
    const [error, setError] = useState(null);

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError(null);
        setPrediction(null);

        try {
            const response = await axios.post("/predict", { hours: parseFloat(hours) });
            setPrediction(response.data.predictedMarks);
        } catch (err) {
            setError("Failed to fetch prediction. Ensure the server is running.");
        }
    };

    return (
        <div>
            <h1>Student Marks Predictor</h1>
            <form onSubmit={handleSubmit}>
                <input
                    type="number"
                    value={hours}
                    onChange={(e) => setHours(e.target.value)}
                    placeholder="Enter hours studied"
                />
                <button type="submit">Predict</button>
            </form>
            {prediction && <p>Predicted Marks: {prediction}</p>}
            {error && <p style={{ color: "red" }}>{error}</p>}
        </div>
    );
};

export default PredictForm;
EOL

cat > frontend/src/services/api.js <<EOL
import axios from "axios";

const api = axios.create({
    baseURL: "http://localhost:5000", // Node.js backend URL
});

export default api;
EOL

cat > frontend/public/index.html <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Marks Predictor</title>
</head>
<body>
    <div id="root"></div>
</body>
</html>
EOL

cat > frontend/package.json <<EOL
{
  "name": "student-marks-predictor-frontend",
  "version": "1.0.0",
  "description": "React frontend for the student marks predictor",
  "main": "index.js",
  "dependencies": {
    "axios": "^1.4.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "scripts": {
    "start": "react-scripts start"
  }
}
EOL

echo "Project structure created successfully!"
