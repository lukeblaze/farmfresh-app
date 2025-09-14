import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProduceCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final int price;
  final double avgRating;
  final VoidCallback onTap;

  const ProduceCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.price,
    required this.avgRating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  const SizedBox(height: 4),
                  Text('₦$price', style: const TextStyle(fontSize: 14, color: Colors.green)),
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