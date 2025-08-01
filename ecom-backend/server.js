
const express = require('express');
const mongoose = require('./database/db');

const app = express();

app.use(express.json());
const PORT = process.env.PORT || 3002;
require('dotenv').config();



app.get('/', (req, res) => {
    res.send('Welcome to the E-commerce API');
});

app.listen(PORT, () => {        
    console.log(`Server is running on port ${PORT}`);
});

module.exports = app;






