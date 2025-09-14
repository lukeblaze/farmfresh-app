import 'package:flutter/material.dart';
import 'produce_detail_screen.dart';
import 'category_screen.dart';
import 'settings_screen.dart';
import 'farmers_corner_screen.dart';
import 'farmer_profile_screen.dart';
import 'message_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Promoted Goods', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildProduceCard(context, 'Fresh Apples', 'assets/images/apples.jpg', 120),
        _buildProduceCard(context, 'Cabbage Deal', 'assets/images/cabbage.jpg', 60),
        _buildProduceCard(context, 'Mint Leaves', 'assets/images/mint.jpg', 50),
        _buildProduceCard(context, 'Carrots Pack', 'assets/images/carrots.jpg', 80),
      ],
    );
  }

  Widget _buildProduceCard(BuildContext context, String title, String imagePath, int price) {
    double avgRating = _averageRating(title);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProduceDetailScreen(
              produce: {
                'name': title,
                'image': imagePath,
                'price': price,
                'description': 'Fresh farm-picked $title available now!',
              },
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  RatingBarIndicator(
                    rating: avgRating,
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 18,
                    unratedColor: Colors.grey[300],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
