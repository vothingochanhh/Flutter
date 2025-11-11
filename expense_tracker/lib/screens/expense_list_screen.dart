import 'package:expense_tracker/screens/sumary_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/expense.dart';
import 'add_expense_screen.dart'; // Màn hình thêm
// import '../summary_screen.dart'; // Màn hình biểu đồ

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          // Nút đi đến màn hình Biểu đồ
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SummaryScreen()),
              );
            },
          ),
        ],
      ),
      // Đây là phần "diệu kỳ" của hive_flutter:
      body: ValueListenableBuilder(
        // 1. Lắng nghe "Hộp" 'expenses'
        valueListenable: Hive.box<Expense>('expenses').listenable(),
        builder: (context, Box<Expense> box, _) {
          // 2. builder sẽ tự động chạy lại MỖI KHI dữ liệu trong hộp thay đổi

          if (box.values.isEmpty) {
            return const Center(child: Text('No expenses yet.'));
          }

          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              // Lấy chi tiêu từ Hộp
              final expense = box.getAt(index)!;

              return ListTile(
                title: Text(expense.name),
                subtitle: Text(
                  '${expense.category} - ${expense.date.toLocal().toString().split(' ')[0]}',
                ),
                trailing: Text(
                  '${expense.amount.toStringAsFixed(0)} VND',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // (Bạn có thể thêm nút delete ở đây, dùng box.deleteAt(index))
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
      ),
    );
  }
}
