import 'package:flutter/material.dart';
import '../models/alcohol_product.dart';
import '../utils/app_config.dart';

class ProductCard extends StatelessWidget {
  final AlcoholProduct product;
  final bool isBestValue;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    Key? key,
    required this.product,
    required this.isBestValue,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: isBestValue ? Colors.blue.shade50 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isBestValue
            ? BorderSide(color: Colors.blue.shade300, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (isBestValue)
                  const Chip(
                    label: Text('Best Value'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.attach_money, 
              'Price', 
              '\$${AlcoholProduct.formatDecimal(product.price, AppConfig.pricePrecision)}'
            ),
            _buildInfoRow(
              Icons.local_drink, 
              'Volume', 
              '${AlcoholProduct.formatDecimal(product.volume, AppConfig.volumePrecision)} ml'
            ),
            _buildInfoRow(
              Icons.percent, 
              'Alcohol', 
              '${AlcoholProduct.formatDecimal(product.alcoholPercentage * (product.alcoholPercentage < 1 ? 100.into() : 1.into()), AppConfig.alcoholPrecision)}%'
            ),
            const Divider(height: 24),
            _buildHighlightRow(
              'Value ratio', 
              '${AlcoholProduct.formatDecimal(product.valueRatio, AppConfig.ratioPrecision)} ml/\$', 
              isBestValue
            ),
            _buildInfoRow(
              Icons.money, 
              'Price per liter', 
              '\$${AlcoholProduct.formatDecimal(product.pricePerLiter, AppConfig.pricePrecision)}/L'
            ),
            _buildInfoRow(
              Icons.local_bar, 
              'Standard drinks', 
              AlcoholProduct.formatDecimal(product.standardDrinks, AppConfig.drinksPrecision)
            ),
            _buildInfoRow(
              Icons.shopping_cart, 
              'Price per drink',
              '\$${AlcoholProduct.formatDecimal(product.pricePerStandardDrink, AppConfig.pricePrecision)}'
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                  tooltip: 'Edit product',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Product'),
                        content: Text('Are you sure you want to delete "${product.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              onDelete();
                            },
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('DELETE'),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Delete product',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildHighlightRow(String label, String value, bool highlight) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: highlight ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.green[800] : null,
            ),
          ),
        ],
      ),
    );
  }
}