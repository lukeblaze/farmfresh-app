import 'package:flutter/material.dart';

class FullImageViewScreen extends StatelessWidget {
  final String imagePath;
  final bool allowDownload;

  const FullImageViewScreen({
    super.key,
    required this.imagePath,
    this.allowDownload = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Image'),
        backgroundColor: const Color(0xFF8BC34A),
        actions: allowDownload
            ? [
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image download not available yet.'),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
