import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // STEP 1: Initialize notification system
  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(initSettings);
  }

  // STEP 2: Schedule daily Verse of the Day notification
  static Future<void> scheduleDailyVerse({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'verse_of_day',
      'Verse of the Day',
      channelDescription: 'Daily Bhagavad Gita Verse',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
  0,
  title,
  body,
  _nextInstanceOf7AM(),
  notificationDetails,
  uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
  matchDateTimeComponents: DateTimeComponents.time,
  androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, // 🔑 FIX
);

  }
  // STEP 3: Decide next 7 AM
  static tz.TZDateTime _nextInstanceOf7AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 7);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = now.add(const Duration(seconds: 10));
    }

    return scheduledDate;
  }
}
