import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        backgroundColor: const Color(0xFF8BC34A),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Customize your experience',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Theme toggle
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (val) {
              setState(() {
                isDarkMode = val;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isDarkMode
                      ? 'Dark mode activated'
                      : 'Light mode activated'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            activeColor: const Color(0xFF8BC34A),
          ),

          // Notifications toggle
          SwitchListTile(
            title: const Text('Receive Notifications'),
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() {
                notificationsEnabled = val;
              });
            },
            activeColor: const Color(0xFF8BC34A),
          ),

          const Divider(height: 30, thickness: 1),

          // Font size selection
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Font Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<double>(
            title: const Text('Small'),
            value: 14,
            groupValue: fontSize,
            onChanged: (val) {
              setState(() {
                fontSize = val!;
              });
            },
          ),
          RadioListTile<double>(
            title: const Text('Medium'),
            value: 16,
            groupValue: fontSize,
            onChanged: (val) {
              setState(() {
                fontSize = val!;
              });
            },
          ),
          RadioListTile<double>(
            title: const Text('Large'),
            value: 18,
            groupValue: fontSize,
            onChanged: (val) {
              setState(() {
                fontSize = val!;
              });
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
