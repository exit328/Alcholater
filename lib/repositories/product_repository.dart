import 'package:decimal/decimal.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/graphql_client.dart';
import '../graphql/product_queries.dart';
import '../models/alcohol_product.dart';
import '../utils/app_config.dart';

class ProductRepository {
  /// Get all products for a user
  Future<List<AlcoholProduct>> getProducts({String? userId}) async {
    try {
      final QueryResult result = await GraphQLService.query(
        getAllProductsQuery,
        variables: {
          'userId': userId ?? AppConfig.defaultUserId,
        },
      );
      
      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ?? 
            'Failed to fetch products');
      }
      
      final List<dynamic> productData = result.data?['products'] ?? [];
      return productData
          .map((json) => AlcoholProduct.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
  
  /// Get a product by ID
  Future<AlcoholProduct> getProductById(String id) async {
    try {
      final QueryResult result = await GraphQLService.query(
        getProductByIdQuery,
        variables: {'id': id},
      );
      
      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ?? 
            'Failed to fetch product');
      }
      
      final productData = result.data?['product'];
      if (productData == null) {
        throw Exception('Product not found');
      }
      
      return AlcoholProduct.fromJson(productData);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
  
  /// Create a new product
  Future<AlcoholProduct> createProduct(AlcoholProduct product) async {
    try {
      // Ensure the product has a user ID
      final productWithUserId = product.userId == null 
          ? product.copyWith(userId: AppConfig.defaultUserId) 
          : product;
      
      final QueryResult result = await GraphQLService.mutate(
        createProductMutation,
        variables: {
          'input': productWithUserId.toJson(),
        },
      );
      
      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ?? 
            'Failed to create product');
      }
      
      final productData = result.data?['createProduct'];
      if (productData == null) {
        throw Exception('Failed to create product: No data returned');
      }
      
      return AlcoholProduct.fromJson(productData);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }
  
  /// Update an existing product
  Future<AlcoholProduct> updateProduct(AlcoholProduct product) async {
    try {
      final QueryResult result = await GraphQLService.mutate(
        updateProductMutation,
        variables: {
          'id': product.id,
          'input': product.toJson(),
        },
      );
      
      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ?? 
            'Failed to update product');
      }
      
      final productData = result.data?['updateProduct'];
      if (productData == null) {
        throw Exception('Failed to update product: No data returned');
      }
      
      return AlcoholProduct.fromJson(productData);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
  
  /// Delete a product
  Future<bool> deleteProduct(String id) async {
    try {
      final QueryResult result = await GraphQLService.mutate(
        deleteProductMutation,
        variables: {'id': id},
      );
      
      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ?? 
            'Failed to delete product');
      }
      
      return result.data?['deleteProduct'] ?? false;
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}