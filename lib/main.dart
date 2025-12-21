import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gita/Screens/homescreen.dart';
import 'package:gita/Screens/mainscreen.dart';
import 'package:gita/Screens/splashscreen.dart';
import 'package:rive/rive.dart' hide Image, LinearGradient;

// ✅ REQUIRED IMPORT FOR LOCAL NOTIFICATIONS
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  // ✅ INITIALIZE LOCAL NOTIFICATIONS
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    // 🔔 Firebase push notification permission (unchanged)
    messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhagavad Gita App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Poppins',
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
