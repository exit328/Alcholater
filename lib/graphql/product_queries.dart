/// GraphQL queries and mutations for alcohol products

// Query to get all products for a user
const String getAllProductsQuery = r'''
query GetProducts($userId: String) {
  products(where: { userId: $userId }) {
    id
    name
    price
    volume
    alcoholPercentage
    userId
  }
}
''';

// Query to get a product by ID
const String getProductByIdQuery = r'''
query GetProduct($id: ID!) {
  product(id: $id) {
    id
    name
    price
    volume
    alcoholPercentage
    userId
  }
}
''';

// Mutation to create a new product
const String createProductMutation = r'''
mutation CreateProduct($input: ProductInput!) {
  createProduct(input: $input) {
    id
    name
    price
    volume
    alcoholPercentage
    userId
  }
}
''';

// Mutation to update an existing product
const String updateProductMutation = r'''
mutation UpdateProduct($id: ID!, $input: ProductInput!) {
  updateProduct(id: $id, input: $input) {
    id
    name
    price
    volume
    alcoholPercentage
    userId
  }
}
''';

// Mutation to delete a product
const String deleteProductMutation = r'''
mutation DeleteProduct($id: ID!) {
  deleteProduct(id: $id)
}
''';