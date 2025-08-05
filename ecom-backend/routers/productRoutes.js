const express = require('express');
const router = express.Router();
const isAdmin = require('../middlewares/isAdmin');
const productController = require('../controllers/productController');
const { addProduct, deleteProduct } = productController;



// Admin routes for product management
router.post('/add',   addProduct);
router.delete('/:productId',   deleteProduct);

// Public routes for product retrieval
router.get('/', productController.getAllProducts);
router.get('/:productId', productController.getProductById);

module.exports = router;

