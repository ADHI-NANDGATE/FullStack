
const express = require('express');
const mongoose = require('./database/db');
const authRoutes = require('./routers/auth');

const app = express();

app.use(express.json());
const PORT = process.env.PORT || 3002;
require('dotenv').config();


// Routes
app.use('/auth', authRoutes);

// Test route
app.get('/', (req, res) => {
    res.send('Server is running');
});



app.listen(PORT, () => {        
    console.log(`Server is running on port ${PORT}`);
});

module.exports = app;






