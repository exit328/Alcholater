class AlcoholProduct {
  final String name;
  final double price;
  final double volume; // in milliliters
  final double alcoholPercentage; // as a decimal (e.g., 0.40 for 40%)

  AlcoholProduct({
    required this.name,
    required this.price,
    required this.volume,
    required this.alcoholPercentage,
  });

  /// Calculate the value ratio (ml of pure alcohol per dollar)
  double get valueRatio {
    double pureAlcoholMl = volume * alcoholPercentage;
    return pureAlcoholMl / price;
  }

  /// Calculate the price per liter
  double get pricePerLiter {
    return (price / volume) * 1000;
  }

  /// Calculate the standard drinks
  double get standardDrinks {
    // A standard drink contains about 14 grams of pure alcohol
    // Density of alcohol is about 0.789 g/ml
    double pureAlcoholMl = volume * alcoholPercentage;
    double pureAlcoholGrams = pureAlcoholMl * 0.789;
    return pureAlcoholGrams / 14;
  }

  /// Calculate the price per standard drink
  double get pricePerStandardDrink {
    return price / standardDrinks;
  }
}