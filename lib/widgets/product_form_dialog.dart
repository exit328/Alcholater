import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/alcohol_product.dart';
import '../utils/app_config.dart';

class ProductFormDialog extends StatefulWidget {
  final AlcoholProduct? product;
  final Function(AlcoholProduct) onSave;

  const ProductFormDialog({
    Key? key,
    this.product,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _volumeController;
  late final TextEditingController _alcoholPercentageController;
  
  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing values if editing
    _nameController = TextEditingController(
      text: widget.product?.name ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product != null 
        ? AlcoholProduct.formatDecimal(widget.product!.price, AppConfig.pricePrecision) 
        : '',
    );
    _volumeController = TextEditingController(
      text: widget.product != null 
        ? AlcoholProduct.formatDecimal(widget.product!.volume, AppConfig.volumePrecision) 
        : '',
    );
    _alcoholPercentageController = TextEditingController(
      text: widget.product != null 
        ? AlcoholProduct.formatDecimal(
            widget.product!.alcoholPercentage * (widget.product!.alcoholPercentage < Decimal.parse('1') 
              ? Decimal.parse('100') 
              : Decimal.parse('1')), 
            AppConfig.alcoholPrecision) 
        : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _volumeController.dispose();
    _alcoholPercentageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final product = AlcoholProduct(
          id: widget.product?.id,
          userId: widget.product?.userId,
          name: _nameController.text,
          price: Decimal.parse(_priceController.text),
          volume: Decimal.parse(_volumeController.text),
          // Convert percentage to decimal (e.g., 40% -> 0.40)
          alcoholPercentage: Decimal.parse(_alcoholPercentageController.text) / Decimal.parse('100'),
        );
        
        widget.onSave(product);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // Allow digits, one decimal point, and limit to 2 decimal places
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  try {
                    final price = Decimal.parse(value);
                    if (price <= Decimal.zero) {
                      return 'Price must be greater than 0';
                    }
                  } catch (e) {
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // Allow digits and one decimal point
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a volume';
                  }
                  try {
                    final volume = Decimal.parse(value);
                    if (volume <= Decimal.zero) {
                      return 'Volume must be greater than 0';
                    }
                  } catch (e) {
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // Allow digits, one decimal point, and limit to 1 decimal place
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an alcohol percentage';
                  }
                  try {
                    final percentage = Decimal.parse(value);
                    if (percentage <= Decimal.zero) {
                      return 'Percentage must be greater than 0';
                    }
                    if (percentage > Decimal.parse('100')) {
                      return 'Percentage must be 100 or less';
                    }
                  } catch (e) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(isEditing ? 'SAVE' : 'ADD'),
        ),
      ],
    );
  }
}