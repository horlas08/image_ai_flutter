import 'dart:ui';
import 'package:flutter/material.dart';

class FancyGradientBackground extends StatelessWidget {
  final Widget? child;

  const FancyGradientBackground({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // TOP ELLIPSE - EBC894
          Positioned(
            top: -size.height * 0.3,
            left: -size.width * 0.2,
            child: Opacity(
              opacity: 0.8,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 150, sigmaY: 150),
                child: Container(
                  width: size.width * 1.4,   // Wide ellipse
                  height: size.height * 0.8, // Covers half screen
                  decoration: const BoxDecoration(
                    color: Color(0xFFEBC894),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      
          // BOTTOM ELLIPSE - B49EF4
          Positioned(
            bottom: -size.height * 0.3,
            right: -size.width * 0.2,
            child: Opacity(
              opacity: 0.8,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                child: Container(
                  width: size.width * 1.4,
                  height: size.height * 0.8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB49EF4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      
          // CONTENT
          if (child != null) child!,
        ],
      ),
    );
  }
}
