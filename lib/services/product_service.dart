import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alcohol_product.dart';

class ProductService {
  static const String _storageKey = 'alcohol_products';
  
  /// Load all products from local storage
  Future<List<AlcoholProduct>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    
    if (jsonString == null) return [];
    
    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) => AlcoholProduct.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      print('Error loading products: $e');
      return [];
    }
  }
  
  /// Save all products to local storage
  Future<bool> saveProducts(List<AlcoholProduct> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = products.map((product) => product.toJson()).toList();
    return await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
  
  /// Add a single product and save
  Future<bool> addProduct(AlcoholProduct product, List<AlcoholProduct> currentProducts) async {
    final updatedProducts = [...currentProducts, product];
    return await saveProducts(updatedProducts);
  }
  
  /// Delete a product by id
  Future<bool> deleteProduct(String id, List<AlcoholProduct> currentProducts) async {
    final updatedProducts = currentProducts.where((product) => product.id != id).toList();
    return await saveProducts(updatedProducts);
  }
  
  /// Update a product by id
  Future<bool> updateProduct(AlcoholProduct updatedProduct, List<AlcoholProduct> currentProducts) async {
    final index = currentProducts.indexWhere((product) => product.id == updatedProduct.id);
    
    if (index == -1) return false;
    
    final updatedProducts = [...currentProducts];
    updatedProducts[index] = updatedProduct;
    return await saveProducts(updatedProducts);
  }
}