#!/bin/bash

# Create project directory structure
mkdir -p my-web-app/client/src/components
mkdir -p my-web-app/client/src/pages
mkdir -p my-web-app/client/public
mkdir -p my-web-app/server/models
mkdir -p my-web-app/server/routes
mkdir -p my-web-app/server/uploads

# Create client-side files
echo '{
  "name": "client",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "react-router-dom": "^6.0.0",
    "axios": "^1.0.0"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}' > my-web-app/client/package.json

# Insert code into frontend files
echo "import React from 'react'; import { BrowserRouter as Router, Route, Routes } from 'react-router-dom'; import SignupPage from './pages/SignupPage'; import LoginPage from './pages/LoginPage'; import FormPage from './pages/FormPage'; function App() { return (<Router><Routes><Route path='/signup' element={<SignupPage />} /><Route path='/login' element={<LoginPage />} /><Route path='/form' element={<FormPage />} /></Routes></Router>); } export default App;" > my-web-app/client/src/App.js

echo "import React from 'react'; import SignupForm from '../components/SignupForm'; const SignupPage = () => { return (<div><h1>Signup</h1><SignupForm /></div>); }; export default SignupPage;" > my-web-app/client/src/pages/SignupPage.js

echo "import React from 'react'; import LoginForm from '../components/LoginForm'; const LoginPage = () => { return (<div><h1>Login</h1><LoginForm /></div>); }; export default LoginPage;" > my-web-app/client/src/pages/LoginPage.js

echo "import React, { useState } from 'react'; import axios from 'axios'; const FormPage = () => { const [name, setName] = useState(''); const [email, setEmail] = useState(''); const [phone, setPhone] = useState(''); const [dob, setDob] = useState(''); const [resume, setResume] = useState(null); const handleFileChange = (e) => { setResume(e.target.files[0]); }; const handleSubmit = async (e) => { e.preventDefault(); const formData = new FormData(); formData.append('name', name); formData.append('email', email); formData.append('phone', phone); formData.append('dob', dob); formData.append('resume', resume); try { const response = await axios.post('http://localhost:5000/api/submit', formData, { headers: { 'Content-Type': 'multipart/form-data' }}); console.log(response.data); } catch (error) { console.error('Error submitting form', error); }}; return (<div><h1>Submit Your Details</h1><form onSubmit={handleSubmit}><div><label>Name: </label><input type='text' value={name} onChange={(e) => setName(e.target.value)} /></div><div><label>Email: </label><input type='email' value={email} onChange={(e) => setEmail(e.target.value)} /></div><div><label>Phone: </label><input type='text' value={phone} onChange={(e) => setPhone(e.target.value)} /></div><div><label>Date of Birth: </label><input type='date' value={dob} onChange={(e) => setDob(e.target.value)} /></div><div><label>Resume: </label><input type='file' onChange={handleFileChange} /></div><button type='submit'>Submit</button></form></div>); }; export default FormPage;" > my-web-app/client/src/pages/FormPage.js

echo "import React, { useState } from 'react'; import axios from 'axios'; const SignupForm = () => { const [name, setName] = useState(''); const [email, setEmail] = useState(''); const [password, setPassword] = useState(''); const handleSubmit = async (e) => { e.preventDefault(); try { const response = await axios.post('http://localhost:5000/api/signup', { name, email, password }); console.log(response.data); } catch (error) { console.error('Error during signup', error); }}; return (<form onSubmit={handleSubmit}><div><label>Name: </label><input type='text' value={name} onChange={(e) => setName(e.target.value)} /></div><div><label>Email: </label><input type='email' value={email} onChange={(e) => setEmail(e.target.value)} /></div><div><label>Password: </label><input type='password' value={password} onChange={(e) => setPassword(e.target.value)} /></div><button type='submit'>Signup</button></form>); }; export default SignupForm;" > my-web-app/client/src/components/SignupForm.js

echo "import React, { useState } from 'react'; import axios from 'axios'; const LoginForm = () => { const [email, setEmail] = useState(''); const [password, setPassword] = useState(''); const handleSubmit = async (e) => { e.preventDefault(); try { const response = await axios.post('http://localhost:5000/api/login', { email, password }); console.log(response.data); } catch (error) { console.error('Error during login', error); }}; return (<form onSubmit={handleSubmit}><div><label>Email: </label><input type='email' value={email} onChange={(e) => setEmail(e.target.value)} /></div><div><label>Password: </label><input type='password' value={password} onChange={(e) => setPassword(e.target.value)} /></div><button type='submit'>Login</button></form>); }; export default LoginForm;" > my-web-app/client/src/components/LoginForm.js

# Create backend files
echo "const express = require('express'); const mongoose = require('mongoose'); const multer = require('multer'); const User = require('./models/User'); const userRoutes = require('./routes/userRoutes'); const app = express(); const port = 5000; app.use(express.json()); app.use(express.urlencoded({ extended: true })); app.use('/uploads', express.static(path.join(__dirname, 'uploads'))); app.use('/api', userRoutes); mongoose.connect('mongodb://localhost:27017/userdata', { useNewUrlParser: true, useUnifiedTopology: true }) .then(() => console.log('MongoDB connected')) .catch((err) => console.log(err)); app.listen(port, () => { console.log('Server running on http://localhost:' + port); });" > my-web-app/server/server.js

echo "const mongoose = require('mongoose'); const userSchema = new mongoose.Schema({ name: String, email: String, password: String, resume: String, detailsTxt: String }); const User = mongoose.model('User', userSchema); module.exports = User;" > my-web-app/server/models/User.js

echo "const express = require('express'); const multer = require('multer'); const User = require('../models/User'); const fs = require('fs'); const path = require('path'); const router = express.Router(); const upload = multer({ dest: 'uploads/' }); router.post('/signup', async (req, res) => { const { name, email, password } = req.body; const user = new User({ name, email, password }); await user.save(); res.status(200).json({ message: 'User signed up successfully' }); }); router.post('/login', async (req, res) => { const { email, password } = req.body; const user = await User.findOne({ email, password }); if (!user) { return res.status(400).json({ message: 'Invalid email or password' }); } res.status(200).json({ message: 'Login successful' }); }); router.post('/submit', upload.single('resume'), async (req, res) => { const { name, email, phone, dob } = req.body; const resumePath = req.file ? path.join(__dirname, '../uploads', req.file.filename) : null; const detailsTxt = `Name: ${name}\\nEmail: ${email}\\nPhone: ${phone}\\nDOB: ${dob}`; const user = new User({ name, email, phone, dob, resume: resumePath, detailsTxt }); await user.save(); fs.writeFileSync(path.join(__dirname, '../uploads', `${name}_details.txt`), detailsTxt); res.status(200).json({ message: 'User data saved successfully', user }); }); module.exports = router;" > my-web-app/server/routes/userRoutes.js

# Change directory to the client and install dependencies
cd my-web-app/client
npm install

# Change directory to the server and install dependencies
cd ../server
npm init -y
npm install express mongoose multer

# Back to the root directory
cd ..

# Start the frontend and backend servers
gnome-terminal -- bash -c "cd client && npm start"
gnome-terminal -- bash -c "cd server && node server.js"

echo "Project setup is complete! The frontend and backend are running."
