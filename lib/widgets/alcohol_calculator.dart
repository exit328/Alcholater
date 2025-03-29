import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/alcohol_product.dart';

class AlcoholCalculator extends StatefulWidget {
  const AlcoholCalculator({super.key});

  @override
  State<AlcoholCalculator> createState() => _AlcoholCalculatorState();
}

class _AlcoholCalculatorState extends State<AlcoholCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _volumeController = TextEditingController();
  final _alcoholPercentageController = TextEditingController();

  List<AlcoholProduct> _products = [];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _volumeController.dispose();
    _alcoholPercentageController.dispose();
    super.dispose();
  }

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      final product = AlcoholProduct(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        volume: double.parse(_volumeController.text),
        alcoholPercentage: double.parse(_alcoholPercentageController.text) / 100,
      );

      setState(() {
        _products.add(product);
        _products.sort((a, b) => b.valueRatio.compareTo(a.valueRatio));
      });

      // Clear form
      _nameController.clear();
      _priceController.clear();
      _volumeController.clear();
      _alcoholPercentageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add New Product',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (USD)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _volumeController,
                    decoration: const InputDecoration(
                      labelText: 'Volume (ml)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a volume';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _alcoholPercentageController,
                    decoration: const InputDecoration(
                      labelText: 'Alcohol Percentage (%)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an alcohol percentage';
                      }
                      final percentage = double.tryParse(value);
                      if (percentage == null) {
                        return 'Please enter a valid number';
                      }
                      if (percentage <= 0 || percentage > 100) {
                        return 'Percentage must be between 0 and 100';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addProduct,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Add Product'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Product Comparison',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _products.isEmpty
              ? const Center(
                  child: Text(
                    'No products added yet. Add a product above to compare.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      elevation: 2,
                      color: index == 0 ? Colors.blue.shade100 : null,
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
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                if (index == 0)
                                  const Chip(
                                    label: Text('Best Value'),
                                    backgroundColor: Colors.green,
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Price: \$${product.price.toStringAsFixed(2)}'),
                            Text('Volume: ${product.volume.toStringAsFixed(0)} ml'),
                            Text('Alcohol: ${(product.alcoholPercentage * 100).toStringAsFixed(1)}%'),
                            const Divider(),
                            Text('Value ratio: ${product.valueRatio.toStringAsFixed(2)} ml/\$',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Price per liter: \$${product.pricePerLiter.toStringAsFixed(2)}/L'),
                            Text('Standard drinks: ${product.standardDrinks.toStringAsFixed(1)}'),
                            Text('Price per drink: \$${product.pricePerStandardDrink.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}