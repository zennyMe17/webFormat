const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: String,
  email: String,
  password: String, // Simple password storage, hash in production
  resume: String,   // Path to the uploaded resume
  detailsTxt: String, // Text content for user details
});

const User = mongoose.model('User', userSchema);

module.exports = User;
