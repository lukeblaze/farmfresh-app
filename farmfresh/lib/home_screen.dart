import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import 'produce_detail_screen.dart';
import 'category_screen.dart';
import 'settings_screen.dart';
import 'message_screen.dart';
import 'produce_card.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final Map<String, List<double>> productRatings = {
    'Fresh Apples': [4.5, 5, 4],
    'Cabbage Deal': [3.5, 4],
    'Mint Leaves': [5],
    'Carrots Pack': [4, 4.5],
  };

  final List<Widget> _pages = [
    const Placeholder(), // Home tab placeholder
    const Placeholder(),
    const Placeholder(),
    MessageScreen(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onPopupMenuSelected(String value) {
    switch (value) {
      case 'Categories':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryScreen()));
        break;
      case 'Settings':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        break;
      case 'Logout':
        Navigator.pop(context);
        break;
    }
  }

  double _averageRating(String productName) {
    final ratings = productRatings[productName];
    if (ratings == null || ratings.isEmpty) return 0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🌿 FarmFresh Market',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: const Color(0xFF8BC34A),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: _onPopupMenuSelected,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Categories', child: Text('Categories')),
              PopupMenuItem(value: 'Settings', child: Text('Settings')),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildHomeContent(context) : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF8BC34A),
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Promoted Goods', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              double avgRating = _averageRating(product['title']);
              return ProduceCard(
                title: product['title'],
                imagePath: product['image'],
                price: product['price'],
                avgRating: avgRating,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProduceDetailScreen(
                        produce: {
                          'name': product['title'],
                          'image': product['image'],
                          'price': product['price'],
                          'description': 'Fresh farm-picked ${product['title']} available now!',
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
