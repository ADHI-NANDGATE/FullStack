
const express = require('express');
const authRoutes = require('./routers/auth');
const productRoutes = require('./routers/productRoutes');
const productController = require('./controllers/productController');
const mongoose = require('mongoose');
require('dotenv').config();
require('./database/db'); // Ensure database connection is established
const cors = require('cors');

const app = express();

app.use(express.json());
const PORT = process.env.PORT || 3002;
require('dotenv').config();

// enable CORS
app.use(cors({
    origin: '*', // Allow all origins for simplicity, adjust as needed
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));


// Routes
app.use('/auth', authRoutes);
app.use('/products', productRoutes);

// Test route
app.get('/', (req, res) => {
    res.send('Server is running');
});





app.listen(PORT, () => {        
    console.log(`Server is running on port ${PORT}`);
});

module.exports = app;






