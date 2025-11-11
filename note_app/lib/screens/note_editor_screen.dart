import 'package:flutter/material.dart';
import 'package:note_app/model/note_provider.dart';
import 'package:provider/provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  final int? index;

  const NoteEditorScreen({super.key, this.note, this.index});

  @override
  State<StatefulWidget> createState() => _StateNoteEditorScreen();
}

class _StateNoteEditorScreen extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool get _isEditing =>
      widget.note != null; // Kiểm tra xem đang "Add" hay "Edit"

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      print('Ban chua them note');
      return;
    }
    final newNote = Note(title: title, content: content);

    if (_isEditing) {
      // --- Ra lệnh "Cập nhật" ---
      // Dùng `context.read` (chỉ "ra lệnh", không "lắng nghe")
      context.read<NoteProvider>().updateNote(widget.index!, newNote);
    } else {
      // --- Ra lệnh "Thêm mới" ---
      context.read<NoteProvider>().addNote(newNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'Add Note'),
        actions: [
          // Nút Save
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote, // Gọi hàm save
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Yêu cầu: TextField
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null, // Cho phép viết nhiều dòng
                expands: true, // Mở rộng ra
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
