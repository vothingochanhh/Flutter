import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'model/expense.dart'; // Import model
import 'screens/expense_list_screen.dart'; // Màn hình chính

Future<void> main() async {
  // 1. Phải có khi main là async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Hive
  await Hive.initFlutter();

  // 3. Đăng ký Adapter (đã được tạo ở Bước 3)
  // Hive sẽ không biết class Expense là gì nếu thiếu dòng này
  Hive.registerAdapter(ExpenseAdapter());

  // 4. Mở "Hộp" (Box)
  // Hộp này sẽ chứa các object Expense
  await Hive.openBox<Expense>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData.dark(),
      home: ExpenseListScreen(),
    );
  }
}
