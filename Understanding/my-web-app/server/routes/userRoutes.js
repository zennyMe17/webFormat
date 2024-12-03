const express = require('express');
const multer = require('multer');
const User = require('../models/User');
const fs = require('fs');
const path = require('path');

const router = express.Router();

// Setup multer for file upload
const upload = multer({ dest: 'uploads/' });

// Signup Route
router.post('/signup', async (req, res) => {
  const { name, email, password } = req.body;
  const user = new User({ name, email, password });
  await user.save();
  res.status(200).json({ message: 'User signed up successfully' });
});

// Login Route
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email, password });
  if (!user) {
    return res.status(400).json({ message: 'Invalid email or password' });
  }
  res.status(200).json({ message: 'Login successful' });
});

// Form Submission Route
router.post('/submit', upload.single('resume'), async (req, res) => {
  const { name, email, phone, dob } = req.body;
  const resumePath = req.file ? path.join(__dirname, '../uploads', req.file.filename) : null;

  // Create a string for the text file content
  const detailsTxt = `Name: ${name}\nEmail: ${email}\nPhone: ${phone}\nDOB: ${dob}`;

  // Save user details to MongoDB
  const user = new User({
    name,
    email,
    phone,
    dob,
    resume: resumePath,
    detailsTxt,
  });

  await user.save();
  fs.writeFileSync(path.join(__dirname, '../uploads', `${name}_details.txt`), detailsTxt);

  res.status(200).json({ message: 'User data saved successfully', user });
});

module.exports = router;
