import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gita/Screens/homescreen.dart';
import 'package:gita/Screens/mainscreen.dart';
import 'package:rive/rive.dart' hide Image, LinearGradient;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhagavad Gita App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
    );
  }
}

//HomePage()