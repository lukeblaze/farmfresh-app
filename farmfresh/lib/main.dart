import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Show a dialog, snackbar, or update UI
    if (kDebugMode) {
      print('Received message: ${message.notification?.title}');
    }
  });

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmFresh',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF145A32), // Dark green
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.white,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF145A32),
          secondary: Colors.white,
          surface: Colors.black, // <-- use surface instead of background
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Color(0xFF145A32)),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF145A32),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
