import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class ReccommendedCard extends StatelessWidget {
  final String title;
  final String buttonText;
  final String imageUrl;
  final VoidCallback onClick;

  const ReccommendedCard({
    Key? key,
    required this.title,
    required this.buttonText,
    required this.imageUrl,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: double.infinity,
        height: 200, // Set an appropriate height for the card
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildBase64Image(imageUrl),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24, // Adjust font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      fontSize: 14, // Adjust font size as needed
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBase64Image(String base64String) {
    Uint8List? imageBytes;
    try {
      final String cleanBase64String = base64String.startsWith('data:image') ? base64String.split(',').last : base64String;
      imageBytes = base64Decode(cleanBase64String);
    } catch (e) {
      // Handle error or provide a fallback image
      print("Error decoding Base64 string: $e");
    }

    return imageBytes != null
        ? ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.25), // Darken the image
        BlendMode.darken,
      ),
      child: Image.memory(
        imageBytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.grey, // Fallback color
          alignment: Alignment.center,
          child: Text('Image Error'), // Display an error message or a fallback icon
        ),
      ),
    )
        : Container(
      color: Colors.grey, // Fallback color
      alignment: Alignment.center,
      child: Text('Image Error'), // Display an error message or a fallback icon
    );
  }

}
