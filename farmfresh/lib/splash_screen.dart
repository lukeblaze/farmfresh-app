import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Track visibility of each letter
  final List<bool> _letterVisible = List.filled(9, false);

  @override
  void initState() {
    super.initState();

    // Animate Lottie + then reveal letters one by one
    Future.delayed(const Duration(seconds: 4), () {
      for (int i = 0; i < _letterVisible.length; i++) {
        Future.delayed(Duration(milliseconds: i * 200), () {
          setState(() {
            _letterVisible[i] = true;
          });
        });
      }

      // Move to home after all letters appeared
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> letters = ['F', 'a', 'r', 'm', 'F', 'r', 'e', 's', 'h'];
    final List<Color> letterColors = [
      Colors.white,
      Colors.amber[300]!,
      Colors.orange[300]!,
      Colors.yellow[300]!,
      Colors.greenAccent[100]!,
      Colors.white,
      Colors.amber[300]!,
      Colors.orange[300]!,
      Colors.yellow[300]!,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF8BC34A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation
            Lottie.asset(
              'assets/splash_animation.json',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // Cinematic letter-by-letter animated title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(letters.length, (index) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _letterVisible[index] ? 1.0 : 0.0,
                  child: Text(
                    letters[index],
                    style: TextStyle(
                      color: letterColors[index],
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
