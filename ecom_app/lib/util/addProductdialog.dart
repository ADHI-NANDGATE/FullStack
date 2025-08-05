import 'dart:convert';
import 'dart:io';

import 'package:ecom_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
}



class _AddproductState extends State<Addproduct> {

  bool isLoading = true;
String? errorMessage;

// controllers for text fields
final TextEditingController nameController = TextEditingController();
final TextEditingController priceController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController stockController = TextEditingController();
String? category;
File? selectedImage;

  @override
  void initState() {
    super.initState();
    // Initialize any necessary data here
  } 

  @override
  void dispose() {
    // Dispose of controllers to free up resources
    nameController.dispose();
    priceController.dispose();      
    descriptionController.dispose();
    stockController.dispose();
    super.dispose();
  }


  // File Select
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  // Add a new product to the list
  Future<void> addProduct() async {
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
      print('Image selected: ${selectedImage != null}');

      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/products/add'),
        headers: {'Content-Type': 'application/json'}
        body: json.encode({
          'name': nameController.text,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'description': descriptionController.text,
          'category': category,
          'stock': int.tryParse(stockController.text) ?? 0,
            'imageUrl': selectedImage != null
              ? base64Encode(
                selectedImage!
                  .readAsBytesSync()
                  .sublist(0, selectedImage!.lengthSync() > 2 * 1024 * 1024
                    ? 2 * 1024 * 1024
                    : selectedImage!.lengthSync()))
              : null,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching products: $e';
        isLoading = false;
      });
      print('Error fetching products: $e');
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
        child: ListBody(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(hintText: 'Product Name'),
              controller: nameController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Product Price'),
              controller: priceController,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Product Description',
              ),
              controller: descriptionController,
              maxLines: 3,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(hintText: 'Category'),
              value: category,
              items: <String>['Electronics', 'Clothing', 'Books', 'Other']
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (String? newValue) {
                // Handle category selection
              },
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Stock Quantity'),
              controller: stockController,
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Select Image'),
                  onPressed: _pickImage,
                ),
              ],
            ),
            const SizedBox(height: 16),
            selectedImage != null
                ? Image.file(selectedImage!, height: 200)
                : const Text("No image selected"),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: Text('Cancel')),
        TextButton(onPressed: addProduct, child: Text('Add')),
      ],
    );
  }
}
