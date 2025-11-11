class Message {
  final String text;
  final bool isMe; // true = tin nhắn của tôi, false = của họ

  Message({required this.text, required this.isMe});
}

// Dữ liệu "giả" để hiển thị
final List<Message> mockMessages = [
  Message(text: 'Chào cậu!', isMe: false),
  Message(text: 'Chào!', isMe: true),
  Message(text: 'Đang làm gì đó?', isMe: true),
  Message(text: 'Đang học Flutter, còn cậu?', isMe: false),
  Message(text: 'Tuyệt vời! Tớ cũng vậy.', isMe: false),
  Message(text: 'Project 4 này thú vị thật.', isMe: true),
];
