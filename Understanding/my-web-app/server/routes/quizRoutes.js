const express = require('express');
const fs = require('fs');
const path = require('path');
const router = express.Router();

router.post('/quiz', async (req, res) => {
  const { answers } = req.body;

  // Questions and their corresponding text
  const questions = [
    'How do you handle stress?',
    'How do you deal with a difficult colleague?',
    'What is your approach to teamwork?',
    'How do you handle criticism?',
    'How do you prioritize tasks?',
    'How do you handle failure?',
    'How do you maintain work-life balance?',
    'How do you handle multiple projects at once?',
    'How do you approach learning new skills?',
    'How do you handle conflicts at work?'
  ];

  // Generate the content of the txt file
  let quizContent = 'Quiz Results:\n\n';
  
  questions.forEach((question, index) => {
    quizContent += `Question ${index + 1}: ${question}\n`;
    quizContent += `Ans: ${answers[index]}\n\n`;
  });

  // Create a file name with the current date and time
  const fileName = `quiz_${Date.now()}.txt`;
  const filePath = path.join(__dirname, '../uploads', fileName);

  // Write the quiz content to the text file
  fs.writeFileSync(filePath, quizContent);

  res.status(200).json({
    message: 'Quiz submitted successfully',
    filePath: fileName
  });
});

module.exports = router;
