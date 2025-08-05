import 'dart:convert';

import 'package:ecom_app/config.dart';
import 'package:ecom_app/product_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
  }
  
  // Add these variables to store product data
  List<dynamic> allProducts = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> _fetchAllProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/products'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          allProducts = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products: ${response.statusCode}';
          isLoading = false;
        });
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching products: $e';
        isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAllProducts,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  Text(
                    'All Products (${allProducts.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality to add a new product
                    },
                    child: const Text('Add Product'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Products Display - Vertical Grid
              Expanded(
                child: _buildProductsDisplay(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsDisplay() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading products...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchAllProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (allProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Products Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Products will appear here once they are added',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    // Display products in a vertical scrollable grid
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 products per row
        childAspectRatio: 0.75, // Adjust height/width ratio
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: allProducts.length, // Show ALL products, not just 5
      itemBuilder: (context, index) {
        final product = allProducts[index];
        return ProductCard(
          product: product,
        );
      },
    );
  }
}