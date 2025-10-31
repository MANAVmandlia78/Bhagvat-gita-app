import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to home after 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD180), Color(0xFFFF8A65), Color(0xFFE65100)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🌞 Glowing sun behind Krishna’s head
            Positioned(
              top: size.height * 0.24,
              right: size.height * 0.19,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFFFFE082), // soft golden yellow
                      Color(0xFFFFC107), // bright saffron
                      Colors.transparent,
                    ],
                    stops: [0.2, 0.6, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.8),
                      blurRadius: 60,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),

            // 🪔 Fullscreen Krishna image (no shadow)
            Positioned.fill(
              child: Image.asset(
                'assets/images/splashscreen.png',
                alignment: Alignment.bottomCenter,
              ),
            ),

            // 🌺 Title text at top
            const Positioned(
              top: 70,
              child: Text(
                'भगवद् गीता',
                style: TextStyle(
                  fontFamily: 'NotoSansDevanagari',
                  fontSize: 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 20,
                      color: Colors.orangeAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
