import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class FullImageViewScreen extends StatelessWidget {
  final String imagePath;
  final bool allowDownload;

  const FullImageViewScreen({
    super.key,
    required this.imagePath,
    this.allowDownload = false,
  });

  Future<void> saveImage(BuildContext context) async {
    try {
      final ByteData imageData = await rootBundle.load(imagePath);
      final Uint8List bytes = imageData.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: 'farmfresh_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess']) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to gallery!')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save image.')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

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
                  onPressed: () => saveImage(context),
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
