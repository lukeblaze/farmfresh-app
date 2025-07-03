import 'package:flutter/material.dart';
import 'dart:async';

class ExitScreen extends StatefulWidget {
  const ExitScreen({super.key});

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  String displayText = '';
  final String appName = 'FarmFresh';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    animateText();
  }

  void animateText() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (currentIndex < appName.length) {
        setState(() {
          displayText += appName[currentIndex];
          currentIndex++;
        });
      } else {
        timer.cancel();
        // Wait 2 seconds then exit app
        Future.delayed(const Duration(seconds: 2), () {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop(); // Close ExitScreen
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.green,
      Colors.orange,
      Colors.teal,
      Colors.yellow[700]!,
      Colors.green[700]!,
      Colors.orange[600]!,
      Colors.teal[300]!,
      Colors.lightGreen,
      Colors.amber,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF8BC34A),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(displayText.length, (index) {
            return Text(
              displayText[index],
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: colors[index % colors.length],
              ),
            );
          }),
        ),
      ),
    );
  }
}
