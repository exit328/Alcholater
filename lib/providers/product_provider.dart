import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import '../models/alcohol_product.dart';
import '../repositories/product_repository.dart';
import '../utils/app_config.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  List<AlcoholProduct> _products = [];
  bool _isLoading = false;
  String? _error;
  String? _statusMessage;

  // Getters
  List<AlcoholProduct> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get statusMessage => _statusMessage;
  bool get hasProducts => _products.isNotEmpty;

  // Initialize provider and load products from the backend
  Future<void> init() async {
    _setLoading(true);
    _clearMessages();
    
    try {
      _products = await _repository.getProducts(userId: AppConfig.defaultUserId);
      _sortProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Refresh products from the backend
  Future<void> refreshProducts() async {
    _setLoading(true);
    _clearMessages();
    
    try {
      _products = await _repository.getProducts(userId: AppConfig.defaultUserId);
      _sortProducts();
    } catch (e) {
      _error = 'Failed to refresh products: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Add a new product
  Future<void> addProduct(AlcoholProduct product) async {
    _setLoading(true);
    _clearMessages();
    
    try {
      final savedProduct = await _repository.createProduct(product);
      _products.add(savedProduct);
      _sortProducts();
      _statusMessage = AppConfig.productSavedMessage;
    } catch (e) {
      _error = 'Failed to add product: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    _setLoading(true);
    _clearMessages();
    
    try {
      final success = await _repository.deleteProduct(id);
      if (success) {
        _products.removeWhere((product) => product.id == id);
        _statusMessage = AppConfig.productDeletedMessage;
      } else {
        _error = 'Failed to delete product. Please try again.';
      }
    } catch (e) {
      _error = 'Failed to delete product: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Update a product
  Future<void> updateProduct(AlcoholProduct updatedProduct) async {
    _setLoading(true);
    _clearMessages();
    
    try {
      final savedProduct = await _repository.updateProduct(updatedProduct);
      final index = _products.indexWhere((p) => p.id == savedProduct.id);
      
      if (index != -1) {
        _products[index] = savedProduct;
        _sortProducts();
        _statusMessage = AppConfig.productSavedMessage;
      } else {
        // If the product wasn't in our list, add it
        _products.add(savedProduct);
        _sortProducts();
        _statusMessage = AppConfig.productSavedMessage;
      }
    } catch (e) {
      _error = 'Failed to update product: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Get a single product by ID
  Future<AlcoholProduct?> getProductById(String id) async {
    _setLoading(true);
    _clearMessages();
    
    try {
      return await _repository.getProductById(id);
    } catch (e) {
      _error = 'Failed to get product: ${e.toString()}';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Sort products by value ratio (descending)
  void _sortProducts() {
    _products.sort((a, b) => b.valueRatio.compareTo(a.valueRatio));
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  // Clear error and status messages
  void _clearMessages() {
    _error = null;
    _statusMessage = null;
    notifyListeners();
  }
  
  // Clear just the status message (used after displaying a success message)
  void clearStatusMessage() {
    _statusMessage = null;
    notifyListeners();
  }
  
  // Clear just the error message
  void clearErrorMessage() {
    _error = null;
    notifyListeners();
  }
}