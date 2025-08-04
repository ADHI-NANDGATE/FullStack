const Product = require('../models/product.js'); // Assuming you have a Product model defined

// Add a new product
exports.addProduct = async (req, res) => {
    const { name, description, price, category, stock, imageUrl } = req.body;

    try {
        // Create a new product
        const newProduct = new Product({
            name,
            description,
            price,
            category,
            stock,
            imageUrl
        });

        await newProduct.save();
        res.status(201).json({ message: 'Product added successfully', product: newProduct });
    } catch (error) {
        console.error('Error adding product:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

// Delete a product
exports.deleteProduct = async (req, res) => {
    const { productId } = req.params;

    try {
        // Find and delete the product
        const product = await Product.findByIdAndDelete(productId);
        if (!product) {
            return res.status(404).json({ message: 'Product not found' });
        }

        res.status(200).json({ message: 'Product deleted successfully' });
    } catch (error) {
        console.error('Error deleting product:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

// get all products
exports.getAllProducts = async (req, res) => {
    try {
        const products = await Product.find();
        res.status(200).json(products);
    } catch (error) {
        console.error('Error fetching products:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

// Get a product by ID
exports.getProductById = async (req, res) => {
    const { productId } = req.params;

    try {
        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ message: 'Product not found' });
        }   
        res.status(200).json(product);
    } catch (error) {
        console.error('Error fetching product:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}


