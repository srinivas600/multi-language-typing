import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../models/language_model.dart';

class LearningProvider extends ChangeNotifier {
  Lesson? _currentLesson;
  String _typedText = '';
  int _errors = 0;
  int _correctChars = 0;
  DateTime? _startTime;
  bool _isCompleted = false;

  Lesson? get currentLesson => _currentLesson;
  String get typedText => _typedText;
  int get errors => _errors;
  bool get isCompleted => _isCompleted;

  List<Lesson> getLessonsForLanguage(IndianLanguage language) {
    return Lesson.getLessonsForLanguage(language);
  }

  void startLesson(Lesson lesson) {
    _currentLesson = lesson;
    _typedText = '';
    _errors = 0;
    _correctChars = 0;
    _startTime = DateTime.now();
    _isCompleted = false;
    notifyListeners();
  }

  void onCharTyped(String typedChar, String expectedChar) {
    if (_isCompleted) return;

    _typedText += typedChar;

    if (typedChar == expectedChar) {
      _correctChars++;
    } else {
      _errors++;
    }

    // Check if lesson is completed
    if (_typedText.length >= _currentLesson!.content.length) {
      _isCompleted = true;
    }

    notifyListeners();
  }

  void reset() {
    _typedText = '';
    _errors = 0;
    _correctChars = 0;
    _startTime = DateTime.now();
    _isCompleted = false;
    notifyListeners();
  }

  void clearLesson() {
    _currentLesson = null;
    _typedText = '';
    _errors = 0;
    _correctChars = 0;
    _startTime = null;
    _isCompleted = false;
    notifyListeners();
  }

  int get wpm {
    if (_startTime == null || _typedText.isEmpty) return 0;
    final elapsed = DateTime.now().difference(_startTime!).inSeconds;
    if (elapsed == 0) return 0;
    // Words per minute (average word = 5 characters)
    return ((_typedText.length / 5) / (elapsed / 60)).round();
  }

  double get accuracy {
    final totalTyped = _correctChars + _errors;
    if (totalTyped == 0) return 100.0;
    return (_correctChars / totalTyped) * 100;
  }

  double get progress {
    if (_currentLesson == null) return 0;
    return _typedText.length / _currentLesson!.content.length;
  }
}
