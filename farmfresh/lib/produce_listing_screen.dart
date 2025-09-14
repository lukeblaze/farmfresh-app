import 'package:flutter/material.dart';

class ProduceListingScreen extends StatelessWidget {
  final String category;

  const ProduceListingScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final produceItems = [
      {
        'name': 'Fresh Apples',
        'image': 'assets/images/apples.jpg',
        'price': 120,
        'description': 'Crisp, sweet farm-fresh apples from Nyeri.'
      },
      {
        'name': 'Carrots Pack',
        'image': 'assets/images/carrots.jpg',
        'price': 80,
        'description': 'Locally grown, crunchy and nutritious.'
      },
      {
        'name': 'Mint Leaves',
        'image': 'assets/images/mint.jpg',
        'price': 50,
        'description': 'Fresh mint for tea, cocktails, and garnishing.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Produce'),
        backgroundColor: const Color(0xFF8BC34A),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: produceItems.length,
        itemBuilder: (context, index) {
          final produce = produceItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  produce['image'] as String,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                produce['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${produce['description'] as String}\nKsh ${produce['price']}',
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
// This file defines the ProduceListingScreen which displays a list of produce items