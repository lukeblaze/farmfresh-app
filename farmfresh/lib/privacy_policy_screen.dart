import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: const Color(0xFF145A32),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(Uri.parse('https://your-privacy-policy-url.com')),
      ),
    );
  }
}
// Removed custom WebView class to avoid conflict with imported WebView widget.
// Remove this custom WebView class, as it conflicts with the imported WebView widget.
