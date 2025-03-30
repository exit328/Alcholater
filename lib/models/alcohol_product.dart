import 'package:decimal/decimal.dart';

class AlcoholProduct {
  final String name;
  final Decimal price;
  final Decimal volume; // in milliliters
  final Decimal alcoholPercentage; // as a decimal (e.g., 0.40 for 40%)
  final String id; // unique identifier from MongoDB
  final String? userId; // to associate products with specific users

  AlcoholProduct({
    required this.name,
    required this.price,
    required this.volume,
    required this.alcoholPercentage,
    String? id,
    this.userId,
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Calculate the value ratio (ml of pure alcohol per dollar)
  Decimal get valueRatio {
    Decimal pureAlcoholMl = volume * alcoholPercentage;
    return price.isZero ? Decimal.zero : pureAlcoholMl / price;
  }

  /// Calculate the price per liter
  Decimal get pricePerLiter {
    return volume.isZero ? Decimal.zero : (price / volume) * Decimal.fromInt(1000);
  }

  /// Calculate the standard drinks
  Decimal get standardDrinks {
    // A standard drink contains about 14 grams of pure alcohol
    // Density of alcohol is about 0.789 g/ml
    Decimal pureAlcoholMl = volume * alcoholPercentage;
    Decimal pureAlcoholGrams = pureAlcoholMl * Decimal.parse('0.789');
    return pureAlcoholGrams / Decimal.parse('14');
  }

  /// Calculate the price per standard drink
  Decimal get pricePerStandardDrink {
    return standardDrinks.isZero ? Decimal.zero : price / standardDrinks;
  }
  
  /// Convert product to a JSON map for GraphQL mutations
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'price': price.toString(),
      'volume': volume.toString(),
      'alcoholPercentage': alcoholPercentage.toString(),
    };
    
    // Only include ID if it's not a new product
    if (id.isNotEmpty && !id.contains('DateTime')) {
      data['id'] = id;
    }
    
    if (userId != null) {
      data['userId'] = userId;
    }
    
    return data;
  }
  
  /// Create a product from a GraphQL response
  factory AlcoholProduct.fromJson(Map<String, dynamic> json) {
    // Handle MongoDB _id format (_id or id could be used by the API)
    String productId = '';
    
    if (json.containsKey('id')) {
      productId = json['id'] as String;
    } else if (json.containsKey('_id')) {
      if (json['_id'] is String) {
        productId = json['_id'] as String;
      } else if (json['_id'] is Map) {
        productId = json['_id']['\$oid'] as String;
      }
    }
    
    return AlcoholProduct(
      id: productId,
      name: json['name'] as String,
      price: _parseDecimal(json['price']),
      volume: _parseDecimal(json['volume']),
      alcoholPercentage: _parseDecimal(json['alcoholPercentage']),
      userId: json['userId'] as String?,
    );
  }
  
  /// Helper method to parse various number formats into Decimal
  static Decimal _parseDecimal(dynamic value) {
    if (value == null) return Decimal.zero;
    
    if (value is String) {
      return Decimal.parse(value);
    } else if (value is int) {
      return Decimal.fromInt(value);
    } else if (value is double) {
      return Decimal.parse(value.toString());
    } else if (value is Decimal) {
      return value;
    }
    
    return Decimal.zero;
  }
  
  /// Format a Decimal value for display
  static String formatDecimal(Decimal value, int decimalPlaces) {
    return value.toStringAsFixed(decimalPlaces);
  }
  
  /// Convert a Decimal to double (for legacy compatibility)
  static double decimalToDouble(Decimal value) {
    return double.parse(value.toString());
  }
  
  /// Create a copy of this product with modified properties
  AlcoholProduct copyWith({
    String? name,
    Decimal? price,
    Decimal? volume,
    Decimal? alcoholPercentage,
    String? id,
    String? userId,
  }) {
    return AlcoholProduct(
      name: name ?? this.name,
      price: price ?? this.price,
      volume: volume ?? this.volume,
      alcoholPercentage: alcoholPercentage ?? this.alcoholPercentage,
      id: id ?? this.id,
      userId: userId ?? this.userId,
    );
  }
}