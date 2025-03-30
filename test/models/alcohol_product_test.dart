import 'package:flutter_test/flutter_test.dart';
import 'package:alcholater/models/alcohol_product.dart';

void main() {
  group('AlcoholProduct', () {
    test('valueRatio calculation is correct', () {
      final product = AlcoholProduct(
        name: 'Test Product',
        price: 10.0,
        volume: 750.0,
        alcoholPercentage: 0.40,
      );
      
      // 750 * 0.40 / 10 = 30.0
      expect(product.valueRatio, 30.0);
    });
    
    test('pricePerLiter calculation is correct', () {
      final product = AlcoholProduct(
        name: 'Test Product',
        price: 10.0,
        volume: 750.0,
        alcoholPercentage: 0.40,
      );
      
      // (10 / 750) * 1000 = 13.33...
      expect(product.pricePerLiter, closeTo(13.33, 0.01));
    });
    
    test('standardDrinks calculation is correct', () {
      final product = AlcoholProduct(
        name: 'Test Product',
        price: 10.0,
        volume: 750.0,
        alcoholPercentage: 0.40,
      );
      
      // Pure alcohol ml: 750 * 0.40 = 300
      // Pure alcohol grams: 300 * 0.789 = 236.7
      // Standard drinks: 236.7 / 14 = 16.9...
      expect(product.standardDrinks, closeTo(16.9, 0.1));
    });
    
    test('pricePerStandardDrink calculation is correct', () {
      final product = AlcoholProduct(
        name: 'Test Product',
        price: 10.0,
        volume: 750.0,
        alcoholPercentage: 0.40,
      );
      
      // Price / standard drinks: 10 / 16.9 = 0.59...
      expect(product.pricePerStandardDrink, closeTo(0.59, 0.01));
    });
    
    test('fromJson and toJson work correctly', () {
      final originalProduct = AlcoholProduct(
        id: '123',
        name: 'Test Product',
        price: 10.0,
        volume: 750.0,
        alcoholPercentage: 0.40,
      );
      
      final json = originalProduct.toJson();
      final recreatedProduct = AlcoholProduct.fromJson(json);
      
      expect(recreatedProduct.id, originalProduct.id);
      expect(recreatedProduct.name, originalProduct.name);
      expect(recreatedProduct.price, originalProduct.price);
      expect(recreatedProduct.volume, originalProduct.volume);
      expect(recreatedProduct.alcoholPercentage, originalProduct.alcoholPercentage);
    });
  });
}