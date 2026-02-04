import 'package:flutter/material.dart';
import '../models/language_model.dart';

class LanguageProvider extends ChangeNotifier {
  IndianLanguage _currentLanguage = IndianLanguage.supportedLanguages.first;
  bool _showKeyboard = true;
  String _keyboardMode = 'vowels'; // vowels, consonants, matras, numbers, special
  
  IndianLanguage get currentLanguage => _currentLanguage;
  bool get showKeyboard => _showKeyboard;
  String get keyboardMode => _keyboardMode;
  
  List<IndianLanguage> get availableLanguages => IndianLanguage.supportedLanguages;
  
  void setLanguage(IndianLanguage language) {
    _currentLanguage = language;
    notifyListeners();
  }
  
  void setLanguageByCode(String code) {
    _currentLanguage = IndianLanguage.getByCode(code);
    notifyListeners();
  }
  
  void toggleKeyboard() {
    _showKeyboard = !_showKeyboard;
    notifyListeners();
  }
  
  void showCustomKeyboard() {
    _showKeyboard = true;
    notifyListeners();
  }
  
  void hideCustomKeyboard() {
    _showKeyboard = false;
    notifyListeners();
  }
  
  void setKeyboardMode(String mode) {
    _keyboardMode = mode;
    notifyListeners();
  }
  
  // Get characters for current keyboard mode
  String getCharactersForMode() {
    final layout = _currentLanguage.keyboardLayout;
    switch (_keyboardMode) {
      case 'vowels':
        return layout['vowels'] ?? '';
      case 'consonants':
        return layout['consonants'] ?? '';
      case 'matras':
        return layout['matras'] ?? '';
      case 'numbers':
        return layout['numbers'] ?? '';
      case 'special':
        return layout['special'] ?? '';
      default:
        return layout['vowels'] ?? '';
    }
  }
  
  // Get all keyboard modes available
  List<String> get availableModes {
    if (_currentLanguage.code == 'en') {
      return ['vowels', 'consonants', 'numbers', 'special'];
    }
    return ['vowels', 'consonants', 'matras', 'numbers', 'special'];
  }
  
  // Get display name for keyboard mode
  String getModeDisplayName(String mode) {
    switch (mode) {
      case 'vowels':
        return _currentLanguage.code == 'en' ? 'ABC' : 'स्वर';
      case 'consonants':
        return _currentLanguage.code == 'en' ? 'abc' : 'व्यंजन';
      case 'matras':
        return 'मात्रा';
      case 'numbers':
        return _currentLanguage.code == 'en' ? '123' : '१२३';
      case 'special':
        return '@#₹';
      default:
        return mode;
    }
  }
}

