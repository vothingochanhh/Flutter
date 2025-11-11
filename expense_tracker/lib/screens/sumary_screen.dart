import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/expense.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  // Hàm này xử lý dữ liệu: Gom nhóm chi tiêu theo danh mục
  Map<String, double> _calculateCategoryTotals() {
    final box = Hive.box<Expense>('expenses');
    final Map<String, double> totals = {};

    for (var expense in box.values) {
      // Nếu danh mục chưa có trong Map, gán = 0, sau đó cộng dồn
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }

  // Hàm tạo màu ngẫu nhiên cho đẹp
  Color _getRandomColor(int index) {
    List<Color> colors = [
      Colors.blue.shade300,
      Colors.red.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.yellow.shade300,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _calculateCategoryTotals();
    final totalSpent = categoryTotals.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );

    // Chuyển Map thành list PieChartSectionData
    final sections = categoryTotals.entries.map((entry) {
      final index = categoryTotals.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / totalSpent) * 100;

      return PieChartSectionData(
        color: _getRandomColor(index),
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%', // Hiển thị %
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total Spent: ${totalSpent.toStringAsFixed(0)} VND',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            // Yêu cầu: Hiển thị Biểu đồ
            Expanded(
              child: categoryTotals.isEmpty
                  ? const Center(child: Text('No data to show.'))
                  : PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            // Hiển thị chú thích (Legend)
            Wrap(
              spacing: 10,
              children: categoryTotals.keys.map((key) {
                final index = categoryTotals.keys.toList().indexOf(key);
                return Chip(
                  backgroundColor: _getRandomColor(index),
                  label: Text(key),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
