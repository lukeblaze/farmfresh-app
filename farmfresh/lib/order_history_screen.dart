import 'package:flutter/material.dart';
import '../order_history.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderHistory = OrderHistory.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: const Color(0xFF8BC34A),
        centerTitle: true,
      ),
      body: orderHistory.isEmpty
          ? const Center(
              child: Text(
                'No past orders yet.\nGo place your first one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    title: Text(
                      order['name'] ?? 'Unnamed Customer',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        'Phone: ${order['phone'] ?? 'N/A'}\n'
                        'Address: ${order['address'] ?? 'N/A'}\n'
                        'Total: Ksh ${order['total'] ?? '0'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    trailing: Text(
                      order['date'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
