// backend/server.js
const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Define route to call Flask ML prediction service
app.post('/predict', async (req, res) => {
    const { hours } = req.body;

    if (isNaN(hours)) {
        return res.status(400).send('Invalid input: Hours should be a number');
    }

    try {
        const response = await axios.post('http://localhost:5001/predict', { hours });
        res.json({ predictedMarks: response.data.predictedMarks });
    } catch (err) {
        console.error("Error while calling Flask API:", err);
        res.status(500).send("Error calling Flask ML API");
    }
});

const PORT = 5000;
app.listen(PORT, () => {
    console.log(`Backend server running on port ${PORT}`);
});
