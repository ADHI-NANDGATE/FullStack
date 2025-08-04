import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic>? product;
  
  const ProductCard({
    super.key,
    this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
        child: Card(
          elevation: isHovered ? 8 : 4,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey[50]!,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Section
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue[50]!,
                              Colors.purple[50]!,
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: _buildProductImage(),
                        ),
                      ),
                      // Favorite Button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Product Details Section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        Text(
                          _getProductCategory(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Product Name
                        Text(
                          _getProductName(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Rating (if available)
                        _buildRating(),
                        const Spacer(),
                        // Price Section
                        Row(
                          children: [
                            Text(
                              _getProductPrice(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // // Add to Cart Button
                        // Flexible(
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     child: ElevatedButton(
                        //       onPressed: () {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           SnackBar(
                        //             content: Text('Added ${_getProductName()} to cart!'),
                        //             duration: const Duration(seconds: 2),
                        //             backgroundColor: Colors.green,
                        //           ),
                        //         );
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.blue,
                        //         foregroundColor: Colors.white,
                        //         padding: const EdgeInsets.symmetric(vertical: 8),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(8),
                        //         ),
                        //         elevation: 2,
                        //       ),
                        //       child: const Text(
                        //         'Add to Cart',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: 12,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final product = widget.product;
    
    // Try different possible image field names
    String? imageUrl;
    if (product != null) {
      imageUrl = product['imageUrl'] ?? 
                 product['image'] ?? 
                 product['images']?[0] ?? 
                 product['picture'] ?? 
                 product['photo'];
    }
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image,
              size: 50,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      return Container(
        color: Colors.grey[200],
        child: const Icon(
          Icons.image,
          size: 50,
          color: Colors.grey,
        ),
      );
    }
  }

  String _getProductName() {
    final product = widget.product;
    if (product == null) return 'Product Name';
    
    return product['name'] ?? 
           product['title'] ?? 
           product['productName'] ?? 
           'Product Name';
  }

  String _getProductCategory() {
    final product = widget.product;
    if (product == null) return 'Category';
    
    return product['category'] ?? 
           product['categoryName'] ?? 
           'Category';
  }

  String _getProductPrice() {
    final product = widget.product;
    if (product == null) return '₹0.00';
    
    final price = product['price'] ?? product['cost'] ?? 0;
    return '₹${price.toString()}';
  }

  Widget _buildRating() {
    final product = widget.product;
    if (product == null) return const SizedBox.shrink();
    
    final rating = product['rating'];
    if (rating == null) return const SizedBox.shrink();
    
    double ratingValue = 0.0;
    int reviewCount = 0;
    
    if (rating is Map) {
      ratingValue = (rating['rate'] ?? rating['value'] ?? 0).toDouble();
      reviewCount = rating['count'] ?? rating['reviews'] ?? 0;
    } else if (rating is num) {
      ratingValue = rating.toDouble();
    }
    
    if (ratingValue > 0) {
      return Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 12,
          ),
          const SizedBox(width: 2),
          Text(
            ratingValue.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          if (reviewCount > 0) ...[
            const SizedBox(width: 4),
            Text(
              '($reviewCount)',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      );
    }
    
    return const SizedBox.shrink();
  }
}