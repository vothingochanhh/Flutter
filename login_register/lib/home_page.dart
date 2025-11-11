import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin user hiện tại (không thể null vì StreamBuilder đã lọc)
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          // Nút Đăng xuất
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Khi nhấn, gọi hàm signOut
              // StreamBuilder sẽ tự động "nghe" thấy và ném về Login
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are logged in as:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              user.email ?? 'No Email', // Hiển thị email user
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
