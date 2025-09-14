import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final productId = produce['id']; // Assuming the document ID is used as product ID

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

                  // Order Now button
                  ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;
                      await FirebaseFirestore.instance.collection('orders').add({
                        'userId': user.uid,
                        'productId': productId,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order placed!')),
                      );
                    },
                    // ignore: sort_child_properties_last
                    child: const Text('Order Now'),
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

            // StreamBuilder for real-time reviews
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .doc(productId)
                  .collection('reviews')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final reviews = snapshot.data!.docs;
                return Column(
                  children: reviews.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['comment'] ?? ''),
                      subtitle: Text('Rating: ${data['rating'] ?? ''}'),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewForm extends StatefulWidget {
  final String productId;
  const ReviewForm({super.key, required this.productId});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _controller = TextEditingController();
  double _rating = 5;

  Future<void> _submit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .collection('reviews')
        .add({
      'userId': user.uid,
      'comment': _controller.text,
      'rating': _rating,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _controller.clear();
    setState(() => _rating = 5);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _rating,
          min: 1,
          max: 5,
          divisions: 4,
          label: _rating.toString(),
          onChanged: (v) => setState(() => _rating = v),
        ),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Write a review'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Submit Review')),
      ],
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('Not signed in'));
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final orders = snapshot.data!.docs;
          return ListView(
            children: orders.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text('Product: ${data['productId']}'),
                subtitle: Text('Ordered at: ${data['timestamp']?.toDate()}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
