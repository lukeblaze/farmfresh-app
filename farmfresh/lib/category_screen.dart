import 'package:flutter/material.dart';
import 'produce_listing_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const List<Map<String, dynamic>> categories = [
    {'name': 'Fruits', 'icon': Icons.apple},
    {'name': 'Vegetables', 'icon': Icons.eco},
    {'name': 'Herbs', 'icon': Icons.local_florist},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: const Color(0xFF8BC34A),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(category['icon'], color: Colors.green[700]),
              title: Text(
                category['name'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProduceListingScreen(category: category['name']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
