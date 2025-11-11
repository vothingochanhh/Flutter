import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone_latest/flutter_native_timezone_latest.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Khởi tạo Timezone
    await _configureLocalTimezone();

    // 2. Cài đặt cho Android
    // PHẢI TRÙNG TÊN VỚI FILE ICON (Bước 2.2)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('notification_icon');

    // 3. Cài đặt cho iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // 4. Khởi tạo
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Hàm helper để lấy múi giờ
  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String localTimezone =
        await FlutterNativeTimezoneLatest.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone));
  }

  // Hàm xin quyền (chủ yếu cho Android 13+)
  Future<void> requestPermissions() async {
    // 1. Dùng 'Platform.isAndroid' để kiểm tra HĐH (cách này đúng)
    if (Platform.isAndroid) {
      // Kiểu của biến phải là 'AndroidFlutterLocalNotificationsPlugin'
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      // 3. Bây giờ 'androidImplementation' đã có kiểu đúng
      //    và nó sẽ tìm thấy hàm '.requestNotificationsPermission()'
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    }
  }

  // --- HÀM CHÍNH: Lên lịch ---
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        // Chuyển đổi DateTime sang TZDateTime (bắt buộc)
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel_id', // ID của channel
            'Reminders',
            channelDescription: 'Channel for reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        // Cho phép chạy ngầm
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('Notification scheduled for $scheduledTime');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  // Hủy 1 thông báo
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
