import 'package:flutter/material.dart';
import 'farmer_profile_screen.dart';

class FarmersCornerScreen extends StatelessWidget {
  const FarmersCornerScreen({super.key});

  static const List<Map<String, String>> farmersList = [
    {
      'name': 'Mama Njeri',
      'location': 'Limuru, Kiambu',
      'bio': 'Growing organic vegetables for over 15 years.',
      'image': 'https://via.placeholder.com/150/8BC34A/FFFFFF?text=Farmer+1'
    },
    {
      'name': 'Kamau Fresh Farm',
      'location': 'Nakuru County',
      'bio': 'Supplying fresh fruits and herbs since 2012.',
      'image': 'https://via.placeholder.com/150/8BC34A/FFFFFF?text=Farmer+2'
    },
    {
      'name': 'Wanjiru Gardens',
      'location': 'Embu Town',
      'bio': 'Specialized in organic spices and traditional greens.',
      'image': 'https://via.placeholder.com/150/8BC34A/FFFFFF?text=Farmer+3'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmers' Corner"),
        backgroundColor: const Color(0xFF8BC34A),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: farmersList.length,
        itemBuilder: (context, index) {
          final farmer = farmersList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  farmer['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                farmer['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text('${farmer['location']}\n${farmer['bio']}'),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FarmerProfileScreen(farmer: farmer),
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
