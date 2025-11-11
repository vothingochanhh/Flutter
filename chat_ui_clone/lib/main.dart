import 'package:chat_ui_clone/messager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Icon avatar và tên người nhận
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            // Bạn có thể thay bằng NetworkImage
            child: Icon(Icons.person),
          ),
        ),
        title: const Text('Người nhận'),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: mockMessages.length,
              itemBuilder: (context, index) {
                final message = mockMessages[index];
                return MessageBubble(text: message.text, isMe: message.isMe);
              },
            ),
          ),

          MessageInputBar(),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const MessageBubble({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.blueAccent : Colors.grey.shade800,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
              bottomLeft: Radius.circular(isMe ? 12.0 : 0.0),
              bottomRight: Radius.circular(isMe ? 0.0 : 12.0),
            ),
          ),
          constraints: BoxConstraints(
            // Chiều rộng tối đa là 70% màn hìn
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          // 4. Đệm (padding) và Lề (margin)
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          // 5. Nội dung tin nhắn
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

// Dán class này vào cuối file main.dart

class MessageInputBar extends StatelessWidget {
  const MessageInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Dùng Container để có thể thêm padding và màu nền
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      color: Theme.of(context).appBarTheme.backgroundColor, // Màu nền
      child: SafeArea(
        // Đảm bảo không bị che bởi tai thỏ/cằm
        child: Row(
          children: [
            // Ô nhập văn bản
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nhắn tin...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            // Nút gửi
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: () {
                // Đây là mock UI, nên không cần làm gì cả
                print('Gửi tin nhắn!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
