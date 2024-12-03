import React, { useState } from 'react'; import axios from 'axios'; const FormPage = () => { const [name, setName] = useState(''); const [email, setEmail] = useState(''); const [phone, setPhone] = useState(''); const [dob, setDob] = useState(''); const [resume, setResume] = useState(null); const handleFileChange = (e) => { setResume(e.target.files[0]); }; const handleSubmit = async (e) => { e.preventDefault(); const formData = new FormData(); formData.append('name', name); formData.append('email', email); formData.append('phone', phone); formData.append('dob', dob); formData.append('resume', resume); try { const response = await axios.post('http://localhost:5000/api/submit', formData, { headers: { 'Content-Type': 'multipart/form-data' }}); console.log(response.data); } catch (error) { console.error('Error submitting form', error); }}; return (<div><h1>Submit Your Details</h1><form onSubmit={handleSubmit}><div><label>Name: </label><input type='text' value={name} onChange={(e) => setName(e.target.value)} /></div><div><label>Email: </label><input type='email' value={email} onChange={(e) => setEmail(e.target.value)} /></div><div><label>Phone: </label><input type='text' value={phone} onChange={(e) => setPhone(e.target.value)} /></div><div><label>Date of Birth: </label><input type='date' value={dob} onChange={(e) => setDob(e.target.value)} /></div><div><label>Resume: </label><input type='file' onChange={handleFileChange} /></div><button type='submit'>Submit</button></form></div>); }; export default FormPage;
