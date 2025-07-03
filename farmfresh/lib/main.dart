import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const FarmFreshApp());
}

class FarmFreshApp extends StatelessWidget {
  const FarmFreshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmFresh',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
