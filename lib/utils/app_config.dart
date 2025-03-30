/// Configuration for different environments
class AppConfig {
  // Spring Boot backend URL with GraphQL endpoint
  static const String backendUrl = 'http://localhost:8080';
  static const String graphqlEndpoint = '$backendUrl/graphql';
  
  // User ID - in a real app, this would come from authentication
  static const String defaultUserId = 'demo-user';
  
  // GraphQL request timeout in seconds
  static const int requestTimeoutSeconds = 15;
  
  // Default error messages
  static const String defaultErrorMessage = 
      'An error occurred. Please try again later.';
  static const String networkErrorMessage = 
      'Network error. Please check your connection.';
  static const String connectionErrorMessage = 
      'Cannot connect to the server. Please try again later.';
      
  // Success messages
  static const String productSavedMessage = 'Product saved successfully!';
  static const String productDeletedMessage = 'Product deleted successfully!';
  
  // Display precision for decimal values
  static const int pricePrecision = 2; // $10.99
  static const int volumePrecision = 0; // 750 ml
  static const int alcoholPrecision = 1; // 40.0%
  static const int ratioPrecision = 2; // Value ratio: 30.25 ml/$
  static const int drinksPrecision = 1; // 16.8 standard drinks
}