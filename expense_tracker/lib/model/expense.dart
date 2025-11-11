import 'package:hive/hive.dart';

// 1. Gõ 'part' trước, dù file .g.dart chưa tồn tại
part 'expense.g.dart'; // Tên file này phải khớp

// 2. Báo cho Hive đây là một object (TypeAdapter)
@HiveType(typeId: 0) // typeId là duy nhất cho mỗi class
class Expense extends HiveObject {
  // 3. Đánh số thứ tự cho các trường (field)
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime date;

  Expense({
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
  });
}
