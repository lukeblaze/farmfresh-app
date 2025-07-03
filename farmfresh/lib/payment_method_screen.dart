import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void selectPayment(String method) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$method selected. (Processing not implemented yet)'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        backgroundColor: const Color(0xFF8BC34A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPaymentOption(
            context,
            'M-Pesa',
            Icons.phone_android,
            () => selectPayment('M-Pesa'),
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            context,
            'PayPal',
            Icons.account_balance_wallet,
            () => selectPayment('PayPal'),
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            context,
            'Cash on Delivery',
            Icons.attach_money,
            () => selectPayment('Cash on Delivery'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, IconData icon,
      VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8BC34A), size: 30),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
