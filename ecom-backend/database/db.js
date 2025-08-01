const mongoose = require('mongoose');



const dbURI = process.env.DB_URI || 'mongodb://localhost:27017/mydatabase';
mongoose.connect(dbURI, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => console.log('Database connected successfully'))
    .catch(err => console.error('Database connection error:', err));
module.exports = mongoose;