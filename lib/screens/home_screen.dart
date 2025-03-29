import 'package:flutter/material.dart';
import '../widgets/alcohol_calculator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alcholater'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Alcholater',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(),
                applicationLegalese: '© 2025 Alcholater App',
                children: [
                  const Text(
                    'Alcholater helps you determine the best value when purchasing alcohol products.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: AlcoholCalculator(),
        ),
      ),
    );
  }
}