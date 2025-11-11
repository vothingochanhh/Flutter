import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _titleController = TextEditingController();

  // Biến lưu thời gian người dùng chọn
  DateTime? _selectedDateTime;

  // --- HÀM LOGIC CHÍNH ---

  // Yêu cầu: Dùng DateTimePicker
  Future<void> _pickDateTime() async {
    // 1. Chọn Ngày
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (date == null) return; // Người dùng hủy

    // 2. Chọn Giờ
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _selectedDateTime ?? DateTime.now().add(const Duration(minutes: 1)),
      ),
    );

    if (time == null) return; // Người dùng hủy

    // 3. Kết hợp Ngày + Giờ
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _schedule() {
    final title = _titleController.text;
    if (title.isEmpty || _selectedDateTime == null) {
      // (Hiển thị lỗi nếu thiếu)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title and select a time.'),
        ),
      );
      return;
    }

    // Kiểm tra xem thời gian có ở quá khứ không
    if (_selectedDateTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot schedule a time in the past.')),
      );
      return;
    }

    // 1. Lấy ID ngẫu nhiên (hoặc dùng thời gian làm ID)
    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    // 2. Gọi Service
    NotificationService().scheduleNotification(
      id: id,
      title: title,
      body: 'Reminder for your task!',
      scheduledTime: _selectedDateTime!,
    );

    // 3. Xóa form và báo thành công
    _titleController.clear();
    setState(() {
      _selectedDateTime = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Reminder scheduled!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Yêu cầu: TextField (Tiêu đề)
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title (e.g., Call Mom)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Yêu cầu: DateTimePicker (nút để mở)
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Select Time'),
              subtitle: Text(
                // Dùng intl để format
                _selectedDateTime == null
                    ? 'Not set'
                    : DateFormat(
                        'EEE, MMM d, yyyy  h:mm a',
                      ).format(_selectedDateTime!),
              ),
              onTap: _pickDateTime,
            ),
            const Spacer(),

            // Nút "Lên lịch"
            ElevatedButton(
              onPressed: _schedule,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Schedule Reminder'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
