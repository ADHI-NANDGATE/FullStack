import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecom_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Addproduct extends StatefulWidget {
  final VoidCallback? onProductAdded;
  
  const Addproduct({
    super.key,
    this.onProductAdded,
  });

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  bool isLoading = false;
  String? errorMessage;

  // controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  String? category;
  File? selectedImage;
  Uint8List? compressedImageBytes;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();      
    descriptionController.dispose();
    stockController.dispose();
    super.dispose();
  }

  // Compress image
  Future<Uint8List?> _compressImage(File file) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Compress the image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70, // Adjust quality (0-100)
        minWidth: 800, // Maximum width
        minHeight: 600, // Maximum height
        format: CompressFormat.jpeg,
      );

      if (compressedFile != null) {
        return await compressedFile.readAsBytes();
      }
      return null;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  // File Select with compression
  Future<void> _pickImage() async {
    try {
      setState(() {
        isLoading = true;
      });

      final ImagePicker picker = ImagePicker();
      
      // Show source selection dialog
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source != null) {
        final XFile? image = await picker.pickImage(
          source: source,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 85,
        );

        if (image != null) {
          final File imageFile = File(image.path);
          
          // Show compression dialog
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text('Compressing image...'),
                  ],
                ),
              ),
            );
          }

          // Compress the image
          final compressed = await _compressImage(imageFile);
          
          if (mounted) {
            Navigator.pop(context); // Close compression dialog
          }

          if (compressed != null) {
            setState(() {
              selectedImage = imageFile;
              compressedImageBytes = compressed;
            });

            // Show compression result
            final originalSize = await imageFile.length();
            final compressedSize = compressed.length;
            final compressionRatio = ((originalSize - compressedSize) / originalSize * 100).round();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Image compressed by $compressionRatio% (${_formatBytes(originalSize)} → ${_formatBytes(compressedSize)})',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to compress image'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Format bytes to readable string
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Validate form
  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      _showError('Please enter product name');
      return false;
    }
    if (priceController.text.trim().isEmpty) {
      _showError('Please enter product price');
      return false;
    }
    if (double.tryParse(priceController.text) == null) {
      _showError('Please enter a valid price');
      return false;
    }
    if (category == null) {
      _showError('Please select a category');
      return false;
    }
    if (stockController.text.trim().isEmpty) {
      _showError('Please enter stock quantity');
      return false;
    }
    if (int.tryParse(stockController.text) == null) {
      _showError('Please enter a valid stock quantity');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Add a new product to the list
  Future<void> addProduct() async {
    if (!_validateForm()) return;

    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      print('Adding product...');
      print('Name: ${nameController.text}');
      print('Price: ${priceController.text}');
      print('Description: ${descriptionController.text}');
      print('Category: $category');
      print('Stock: ${stockController.text}');
      print('Compressed image size: ${compressedImageBytes?.length ?? 0} bytes');

      // Prepare request body
      Map<String, dynamic> productData = {
        'name': nameController.text.trim(),
        'price': double.parse(priceController.text.trim()),
        'description': descriptionController.text.trim(),
        'category': category,
        'stock': int.parse(stockController.text.trim()),
      };

      // Add compressed image if available
      if (compressedImageBytes != null) {
        String base64Image = base64Encode(compressedImageBytes!);
        productData['imageUrl'] = 'data:image/jpeg;base64,$base64Image';
      }

      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/products/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(productData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onProductAdded?.call();
        }
      } else {
        setState(() {
          errorMessage = 'Failed to add product: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error adding product: $e';
        isLoading = false;
      });
      print('Error adding product: $e');
    }
  }

  // onCancel
  void onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Product'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                controller: nameController,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Product Price',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                controller: priceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Product Description',
                  border: OutlineInputBorder(),
                ),
                controller: descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: category,
                items: <String>['Electronics', 'Clothing', 'Books', 'Home', 'Sports', 'Other']
                    .map(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    category = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  border: OutlineInputBorder(),
                ),
                controller: stockController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: Text(selectedImage != null 
                          ? 'Change Image' 
                          : 'Select Image'),
                      onPressed: isLoading ? null : _pickImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (selectedImage != null) ...[
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (compressedImageBytes != null)
                  Text(
                    'Compressed size: ${_formatBytes(compressedImageBytes!.length)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ] else
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[50],
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No image selected',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : addProduct,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Product'),
        ),
      ],
    );
  }
}