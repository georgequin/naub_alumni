import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
          borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              imageUrl,
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.25), // Darken the image
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
    margin: EdgeInsets.all(20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24, // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                color: Colors.transparent, // Use the appropriate color for the button
                padding: EdgeInsets.symmetric(vertical: 8), // Adjust padding as needed
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontSize: 14, // Adjust font size as needed
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
        )
      ),
    );
  }
}
