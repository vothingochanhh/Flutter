import 'package:flutter/material.dart';
import 'notification_service.dart'; // Import
import 'reminder_screen.dart'; // Màn hình chính

Future<void> main() async {
  // 1. Phải có khi main là async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Service TRƯỚC KHI app chạy
  await NotificationService().init();
  // 3. Xin quyền (nếu cần)
  await NotificationService().requestPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData.dark(),
      home: ReminderScreen(),
    );
  }
}
