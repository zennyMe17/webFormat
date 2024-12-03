// backend/routes/predict.js
const express = require('express');
const router = express.Router();
const axios = require('axios');

// Route to handle prediction requests
router.post('/predict', async (req, res) => {
    const { hours } = req.body;
    if (isNaN(hours)) {
        return res.status(400).send('Invalid input');
    }
    try {
        const response = await axios.post('http://localhost:5001/predict', { hours });
        res.json({ predictedMarks: response.data.predictedMarks });
    } catch (error) {
        res.status(500).send('Error in calling ML prediction service');
    }
});

module.exports = router;
