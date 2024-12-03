import React, { useState } from 'react'; import axios from 'axios'; const SignupForm = () => { const [name, setName] = useState(''); const [email, setEmail] = useState(''); const [password, setPassword] = useState(''); const handleSubmit = async (e) => { e.preventDefault(); try { const response = await axios.post('http://localhost:5000/api/signup', { name, email, password }); console.log(response.data); } catch (error) { console.error('Error during signup', error); }}; return (<form onSubmit={handleSubmit}><div><label>Name: </label><input type='text' value={name} onChange={(e) => setName(e.target.value)} /></div><div><label>Email: </label><input type='email' value={email} onChange={(e) => setEmail(e.target.value)} /></div><div><label>Password: </label><input type='password' value={password} onChange={(e) => setPassword(e.target.value)} /></div><button type='submit'>Signup</button></form>); }; export default SignupForm;