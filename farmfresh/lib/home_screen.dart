import 'package:flutter/material.dart';
import 'produce_listing_screen.dart';
import 'category_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'message_screen.dart';
import 'produce_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text('FarmFresh'),
        backgroundColor: const Color(0xFF8BC34A),
        centerTitle: true,
        elevation: 4,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'categories') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CategoryScreen()));
              } else if (value == 'messages') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MessageScreen()));
              } else if (value == 'settings') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()));
              } else if (value == 'profile') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'categories', child: Text('Categories')),
              const PopupMenuItem(value: 'messages', child: Text('Messages')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
            ],
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeroHeader(),
          const SizedBox(height: 30),
          _buildSectionTitle('Categories'),
          const SizedBox(height: 12),
          _buildCategoriesRow(context),
          const SizedBox(height: 30),
          _buildSectionTitle('Promoted Goods'),
          const SizedBox(height: 12),
          _buildPromotedGoodsList(context),
          const SizedBox(height: 30),
          _buildSectionTitle('Featured Farmers'),
          const SizedBox(height: 12),
          _buildFeaturedFarmersList(context),
          const SizedBox(height: 30),
          _buildSectionTitle('Discounted Deals'),
          const SizedBox(height: 12),
          _buildDiscountedDealsList(context),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8BC34A), Color(0xFFF7DC6F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: const Color(0xFF8BC34A).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to FarmFresh!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Order fresh produce directly from local farms.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCategoriesRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCategoryButton(context, 'Fruits', Icons.apple),
        _buildCategoryButton(context, 'Vegetables', Icons.eco),
        _buildCategoryButton(context, 'Herbs', Icons.local_florist),
      ],
    );
  }

  Widget _buildCategoryButton(BuildContext context, String title, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProduceListingScreen(category: title)),
        );
      },
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF7DC6F),
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
      ),
    );
  }

  Widget _buildPromotedGoodsList(BuildContext context) {
    final promotedGoods = [
      {'name': 'Fresh Apples', 'image': 'assets/images/apples.jpg'},
      {'name': 'Mint Leaves', 'image': 'assets/images/mint.jpg'},
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: promotedGoods.length,
        itemBuilder: (context, index) {
          final item = promotedGoods[index];
          return _buildImageCard(context, item['name']!, item['image']!);
        },
      ),
    );
  }

  Widget _buildFeaturedFarmersList(BuildContext context) {
    final farmers = [
      {'name': 'Mama Njeri', 'image': 'assets/images/farmer1.jpg'},
      {'name': 'Kamau Fresh', 'image': 'assets/images/farmer2.jpg'},
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: farmers.length,
        itemBuilder: (context, index) {
          final item = farmers[index];
          return _buildImageCard(context, item['name']!, item['image']!);
        },
      ),
    );
  }

  Widget _buildDiscountedDealsList(BuildContext context) {
    final deals = [
      {'name': 'Fresh Cabbage - 20% off', 'image': 'assets/images/cabbage.jpg'},
      {'name': 'Carrots Combo', 'image': 'assets/images/carrots.jpg'},
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: deals.length,
        itemBuilder: (context, index) {
          final item = deals[index];
          return _buildImageCard(context, item['name']!, item['image']!);
        },
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProduceDetailScreen(
              produce: {'name': title, 'image': imagePath},
              description: 'Detailed info about $title.',
            ),
          ),
        );
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: const Color(0xFF8BC34A).withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
