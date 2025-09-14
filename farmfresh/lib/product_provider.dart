import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProductProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get products => _products;

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    _products = snapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  Future<void> addProduct(String title, int price, File imageFile) async {
    // Upload image to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await storageRef.putFile(imageFile);
    final imageUrl = await storageRef.getDownloadURL();

    // Add product to Firestore
    await FirebaseFirestore.instance.collection('products').add({
      'title': title,
      'price': price,
      'image': imageUrl,
    });

    fetchProducts();
  }
}