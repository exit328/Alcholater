import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alcohol_product.dart';
import '../utils/app_config.dart';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;

  ApiResponse({this.data, this.error, required this.success});
  
  // Create a successful response
  factory ApiResponse.success(T data) {
    return ApiResponse(data: data, success: true);
  }
  
  // Create an error response
  factory ApiResponse.error(String message) {
    return ApiResponse(error: message, success: false);
  }
}

/// API client for interacting with the Spring Boot backend
class ApiClient {
  final http.Client _client = http.Client();
  
  // Base URL for the API - will be loaded from AppConfig
  String get baseUrl => AppConfig.apiBaseUrl;
  
  // API endpoints
  String get productsEndpoint => '$baseUrl/api/products';
  
  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Authentication headers would be added here if needed
  };
  
  /// Get all products for a user
  Future<ApiResponse<List<AlcoholProduct>>> getProducts({String? userId}) async {
    try {
      final url = userId != null 
          ? '$productsEndpoint?userId=$userId' 
          : productsEndpoint;
          
      final response = await _client.get(
        Uri.parse(url),
        headers: _headers,
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final products = jsonResponse
            .map((productJson) => AlcoholProduct.fromJson(productJson))
            .toList();
            
        return ApiResponse.success(products);
      } else {
        return ApiResponse.error('Failed to load products: ${response.body}');
      }
    } catch (e) {
      return ApiResponse.error('Error connecting to the server: $e');
    }
  }
  
  /// Create a new product
  Future<ApiResponse<AlcoholProduct>> createProduct(AlcoholProduct product) async {
    try {
      final response = await _client.post(
        Uri.parse(productsEndpoint),
        headers: _headers,
        body: json.encode(product.toJson()),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final productJson = json.decode(response.body);
        return ApiResponse.success(AlcoholProduct.fromJson(productJson));
      } else {
        return ApiResponse.error('Failed to create product: ${response.body}');
      }
    } catch (e) {
      return ApiResponse.error('Error connecting to the server: $e');
    }
  }
  
  /// Update an existing product
  Future<ApiResponse<AlcoholProduct>> updateProduct(AlcoholProduct product) async {
    try {
      final response = await _client.put(
        Uri.parse('$productsEndpoint/${product.id}'),
        headers: _headers,
        body: json.encode(product.toJson()),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final productJson = json.decode(response.body);
        return ApiResponse.success(AlcoholProduct.fromJson(productJson));
      } else {
        return ApiResponse.error('Failed to update product: ${response.body}');
      }
    } catch (e) {
      return ApiResponse.error('Error connecting to the server: $e');
    }
  }
  
  /// Delete a product
  Future<ApiResponse<bool>> deleteProduct(String productId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$productsEndpoint/$productId'),
        headers: _headers,
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error('Failed to delete product: ${response.body}');
      }
    } catch (e) {
      return ApiResponse.error('Error connecting to the server: $e');
    }
  }
  
  /// Get a single product by ID
  Future<ApiResponse<AlcoholProduct>> getProductById(String productId) async {
    try {
      final response = await _client.get(
        Uri.parse('$productsEndpoint/$productId'),
        headers: _headers,
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final productJson = json.decode(response.body);
        return ApiResponse.success(AlcoholProduct.fromJson(productJson));
      } else if (response.statusCode == 404) {
        return ApiResponse.error('Product not found');
      } else {
        return ApiResponse.error('Failed to get product: ${response.body}');
      }
    } catch (e) {
      return ApiResponse.error('Error connecting to the server: $e');
    }
  }
}