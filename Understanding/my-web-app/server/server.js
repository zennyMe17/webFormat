const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors'); // Import CORS
const multer = require('multer');
const path = require('path');
const User = require('./models/User');
const userRoutes = require('./routes/userRoutes');
const quizRoutes = require('./routes/quizRoutes'); // Import quizRoutes
const app = express();
const port = 5000;

// Enable CORS
app.use(cors());

// Body parsers
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Static file serving for uploads
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/api', userRoutes);
app.use('/api', quizRoutes); // Use quizRoutes

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/userdata', { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => console.log('MongoDB connected'))
    .catch((err) => console.log(err));

// Server listener
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
