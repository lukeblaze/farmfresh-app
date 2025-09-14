import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProduceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> produce;

  const ProduceDetailScreen({super.key, required this.produce});

  @override
  State<ProduceDetailScreen> createState() => _ProduceDetailScreenState();
}

class _ProduceDetailScreenState extends State<ProduceDetailScreen> {
  List<Map<String, dynamic>> reviews = [];

  void _showReviewDialog() {
    double userRating = 3.0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  userRating = rating;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Your comment...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  setState(() {
                    reviews.add({
                      'rating': userRating,
                      'comment': commentController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  double _averageRating() {
    if (reviews.isEmpty) return 0;
    return reviews.map((e) => e['rating'] as double).reduce((a, b) => a + b) / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final produce = widget.produce;

    return Scaffold(
      appBar: AppBar(
        title: Text(produce['name']),
        backgroundColor: const Color(0xFF8BC34A),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(produce['image'], height: 250, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(produce['name'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Ksh ${produce['price']}', style: const TextStyle(fontSize: 20, color: Color(0xFF8BC34A))),
                  const SizedBox(height: 16),
                  const Text('About this produce', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(produce['description'], style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: _averageRating(),
                        itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 24,
                      ),
                      const SizedBox(width: 8),
                      Text('(${reviews.length} reviews)')
                    ],
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: _showReviewDialog,
                    icon: const Icon(Icons.rate_review),
                    label: const Text('Leave a Review'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BC34A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reviews List
                  if (reviews.isNotEmpty)
                    const Text('Customer Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...reviews.map((rev) => ListTile(
                        leading: Icon(Icons.person, color: Colors.green),
                        title: Text(rev['comment']),
                        subtitle: Row(
                          children: List.generate(
                              rev['rating'].round(),
                              (index) => const Icon(Icons.star, color: Colors.amber, size: 16)),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
