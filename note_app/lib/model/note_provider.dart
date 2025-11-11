import 'package:flutter/material.dart';

class Note {
  String title;
  String content;

  Note({required this.title, required this.content});
}

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  void updateNote(int index, Note note) {
    _notes[index] = note;
    notifyListeners();
  }
}
