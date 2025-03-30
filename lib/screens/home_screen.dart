import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alcohol_product.dart';
import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_form_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      // Load saved products
      Provider.of<ProductProvider>(context, listen: false).init();
    }
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ProductFormDialog(
        onSave: (product) {
          Provider.of<ProductProvider>(context, listen: false).addProduct(product);
        },
      ),
    );
  }

  void _showEditProductDialog(AlcoholProduct product) {
    showDialog(
      context: context,
      builder: (ctx) => ProductFormDialog(
        product: product,
        onSave: (updatedProduct) {
          Provider.of<ProductProvider>(context, listen: false).updateProduct(updatedProduct);
        },
      ),
    );
  }

  void _deleteProduct(String id) {
    Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
  }

  void _showInfoDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Alcholater',
      applicationVersion: '1.0.0',
      applicationIcon: Image.asset(
        'assets/icon/app_icon.png',
        width: 50,
        height: 50,
        errorBuilder: (ctx, err, _) => const FlutterLogo(size: 50),
      ),
      applicationLegalese: '© 2025 Alcholater App',
      children: [
        const Text(
          'Alcholater helps you determine the best value when purchasing alcohol products.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          'Features:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        _buildFeatureList(),
      ],
    );
  }

  Widget _buildFeatureList() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FeatureItem('Calculate value ratios for alcohol products'),
        _FeatureItem('Compare prices per standard drink'),
        _FeatureItem('Track and save your product comparisons'),
        _FeatureItem('Find the best deals on alcohol'),
        _FeatureItem('Make informed purchasing decisions'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alcholater',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (ctx, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : themeProvider.themeMode == ThemeMode.light
                          ? Icons.dark_mode
                          : Icons.brightness_auto,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Choose Theme'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.brightness_auto),
                            title: const Text('System'),
                            onTap: () {
                              themeProvider.setThemeMode(ThemeMode.system);
                              Navigator.of(context).pop();
                            },
                            selected: themeProvider.themeMode == ThemeMode.system,
                          ),
                          ListTile(
                            leading: const Icon(Icons.light_mode),
                            title: const Text('Light'),
                            onTap: () {
                              themeProvider.setThemeMode(ThemeMode.light);
                              Navigator.of(context).pop();
                            },
                            selected: themeProvider.themeMode == ThemeMode.light,
                          ),
                          ListTile(
                            leading: const Icon(Icons.dark_mode),
                            title: const Text('Dark'),
                            onTap: () {
                              themeProvider.setThemeMode(ThemeMode.dark);
                              Navigator.of(context).pop();
                            },
                            selected: themeProvider.themeMode == ThemeMode.dark,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                tooltip: 'Change Theme',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
            tooltip: 'About',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<ProductProvider>(
            builder: (ctx, productProvider, child) {
              if (productProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (productProvider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${productProvider.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => productProvider.init(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_outline, color: Colors.amber),
                              const SizedBox(width: 8),
                              Text(
                                'Alcohol Value Calculator',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Add alcohol products to compare their value. The app will calculate price per liter, standard drinks, and price per standard drink.',
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _showAddProductDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Product'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: productProvider.hasProducts
                        ? ListView.builder(
                            itemCount: productProvider.products.length,
                            itemBuilder: (ctx, index) {
                              final product = productProvider.products[index];
                              return ProductCard(
                                product: product,
                                isBestValue: index == 0,
                                onEdit: () => _showEditProductDialog(product),
                                onDelete: () => _deleteProduct(product.id),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.local_drink_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No products added yet',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tap "Add Product" to start comparing',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: _showAddProductDialog,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Product'),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  
  const _FeatureItem(this.text);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}