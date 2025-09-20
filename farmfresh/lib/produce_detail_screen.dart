import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProduceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> produce;
  const ProduceDetailScreen({super.key, required this.produce});

  @override
  State<ProduceDetailScreen> createState() => _ProduceDetailScreenState();
}

class _ProduceDetailScreenState extends State<ProduceDetailScreen> {
  List<Map<String, dynamic>> reviews = [];
  bool _loadingOrder = false;
  String _orderError = '';

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
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
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
    return reviews.map((e) => e['rating'] as double).reduce((a, b) => a + b) /
        reviews.length;
  }

  Future<void> _placeOrder() async {
    setState(() {
      _loadingOrder = true;
      _orderError = '';
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'You must be signed in to place an order.';
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'productId': widget.produce['id'] ?? widget.produce['title'],
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Order placed!')));
    } catch (e) {
      setState(() => _orderError = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $_orderError')));
    } finally {
      setState(() => _loadingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final produce = widget.produce;
    final productId =
        produce['id']; // Assuming the document ID is used as product ID

    // Example: Show delete button if user is admin
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin =
        user?.email == 'admin@farmfresh.com'; // Replace with your admin logic

    return Scaffold(
      appBar: AppBar(
        title: Text(produce['name']),
        backgroundColor: const Color(0xFF8BC34A),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(productId)
                    .delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted')),
                );
                Navigator.pop(context); // Go back after deletion
              },
            ),
        ],
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
                  Text(
                    produce['name'],
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ksh ${produce['price']}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF8BC34A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About this produce',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produce['description'],
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: _averageRating(),
                        itemBuilder: (context, index) =>
                            const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 24,
                      ),
                      const SizedBox(width: 8),
                      Text('(${reviews.length} reviews)'),
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
                  _loadingOrder
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _loadingOrder ? null : _placeOrder,
                          child: const Text('Order Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                  if (_orderError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _orderError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Reviews Form
                  ReviewForm(productId: productId),
                  const SizedBox(height: 20),

                  // Reviews List
                  if (reviews.isNotEmpty)
                    const Text(
                      'Customer Reviews',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 8),
                  ...reviews.map(
                    (rev) => ListTile(
                      leading: Icon(Icons.person, color: Colors.green),
                      title: Text(rev['comment']),
                      subtitle: Row(
                        children: List.generate(
                          rev['rating'].round(),
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                if (reviews.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No reviews yet.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final data = reviews[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16,
                      ),
                      child: ListTile(
                        leading: Icon(Icons.star, color: Colors.amber),
                        title: Text(data['comment'] ?? ''),
                        subtitle: Text('Rating: ${data['rating'] ?? ''}'),
                      ),
                    );
                  },
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
  bool _loading = false;
  String _error = '';

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'You must be signed in to submit a review.';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Review submitted!')));
      _controller.clear();
      setState(() => _rating = 5);
    } catch (e) {
      setState(() => _error = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $_error')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          maxRating: 5,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) => setState(() => _rating = rating),
        ),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Write a review'),
        ),
        const SizedBox(height: 8),
        _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: const Text('Submit Review'),
              ),
        if (_error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_error, style: const TextStyle(color: Colors.red)),
          ),
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
