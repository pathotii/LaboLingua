import 'package:flutter/material.dart';

class BookmarkProvider with ChangeNotifier {
  List<Map<String, dynamic>> _bookmarkedWords = [];

  List<Map<String, dynamic>> get bookmarkedWords => List.unmodifiable(_bookmarkedWords); // Return an unmodifiable list

  void setBookmarkedWords(List<Map<String, dynamic>> words) {
    _bookmarkedWords = words;
    notifyListeners();
  }

  void addBookmark(Map<String, dynamic> word) {
    print('Adding bookmark: ${word['word']}');
    _bookmarkedWords = [..._bookmarkedWords, word]; // Create a new list
    notifyListeners();
  }

  void removeBookmark(int wordId) {
    print('Removing bookmark with id: $wordId');
    _bookmarkedWords = _bookmarkedWords.where((item) => item['id'] != wordId).toList(); // Create a new list
    notifyListeners();
  }

  bool isBookmarked(int wordId) {
    return _bookmarkedWords.any((item) => item['id'] == wordId);
  }
}

