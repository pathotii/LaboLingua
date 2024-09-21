import 'package:flutter/material.dart';

class BookmarkProvider with ChangeNotifier {
  List<Map<String, dynamic>> _bookmarkedWords = [];

  List<Map<String, dynamic>> get bookmarkedWords => _bookmarkedWords;

  void setBookmarkedWords(List<Map<String, dynamic>> words) {
    _bookmarkedWords = words;
    notifyListeners();
  }

  void addBookmark(Map<String, dynamic> word) {
    _bookmarkedWords.add(word);
    notifyListeners();
  }

  void removeBookmark(int wordId) {
    _bookmarkedWords.removeWhere((item) => item['id'] == wordId);
    notifyListeners();
  }

  bool isBookmarked(int wordId) {
    return _bookmarkedWords.any((item) => item['id'] == wordId);
  }
}
