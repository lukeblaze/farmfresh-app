import 'package:flutter/material.dart';

class FarmersCornerScreen extends StatelessWidget {
  const FarmersCornerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmers = [
      {
        'name': 'Mama Njeri',
        'location': 'Limuru, Kiambu',
        'image': 'assets/images/farmers/farmer1.jpg',
        'bio':
            'Specializes in organic spinach, kale and fresh indigenous vegetables. Farming sustainably for over 12 years.'
      },
      {
        'name': 'Kamau Fresh',
        'location': 'Nakuru',
        'image': 'assets/images/farmers/farmer2.jpg',
        'bio':
            'Famous for his juicy tomatoes and onions, with a loyal customer base across Rift Valley.'
      },
      {
        'name': 'Wambui Organics',
        'location': 'Nyeri',
        'image': 'assets/images/farmers/farmer3.jpg',
        'bio':
            'Delivers premium avocados and coriander, grown pesticide-free in the highlands.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers\' Corner'),
        backgroundColor: const Color(0xFF8BC34A),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: farmers.length,
        itemBuilder: (context, index) {
          final farmer = farmers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(farmer['image']!, width: 60, height: 60, fit: BoxFit.cover),
              ),
              title: Text(farmer['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${farmer['location']}\n${farmer['bio']}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
