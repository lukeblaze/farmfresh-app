import 'package:flutter/material.dart';
import 'cart_screen.dart';

class ProduceListingScreen extends StatefulWidget {
  final String category;

  const ProduceListingScreen({super.key, required this.category});

  @override
  State<ProduceListingScreen> createState() => _ProduceListingScreenState();
}

class _ProduceListingScreenState extends State<ProduceListingScreen> {
  // Cart items list
  final List<Map<String, dynamic>> cartItems = [];

  // Updated produce data with asset images
  static const List<Map<String, dynamic>> produceList = [
    {
      'name': 'Apples',
      'price': 120,
      'image': 'assets/images/apples.jpg',
      'category': 'Fruits'
    },
    {
      'name': 'Oranges',
      'price': 100,
      'image': 'assets/images/oranges.jpg',
      'category': 'Fruits'
    },
    {
      'name': 'Carrots',
      'price': 80,
      'image': 'assets/images/carrots.jpg',
      'category': 'Vegetables'
    },
    {
      'name': 'Cabbage',
      'price': 60,
      'image': 'assets/images/cabbage.jpg',
      'category': 'Vegetables'
    },
    {
      'name': 'Mint Leaves',
      'price': 50,
      'image': 'assets/images/mint.jpg',
      'category': 'Herbs'
    },
    {
      'name': 'Coriander',
      'price': 30,
      'image': 'assets/images/coriander.jpg',
      'category': 'Herbs'
    },
  ];

  // Method to show enlarged image in dialog
  void showImageDialog(String imagePath, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredList = produceList
        .where((item) => item['category'] == widget.category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} List'),
        backgroundColor: const Color(0xFF8BC34A),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: cartItems),
                ),
              );
            },
          )
        ],
      ),
      body: filteredList.isEmpty
          ? const Center(
              child: Text(
                'No produce available in this category.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: GestureDetector(
                      onTap: () {
                        showImageDialog(item['image'], item['name']);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Ksh ${item['price']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      color: Colors.green[700],
                      onPressed: () {
                        setState(() {
                          cartItems.add(item);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item['name']} added to cart!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
