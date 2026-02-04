import 'package:flutter/services.dart';
import 'keyboard_mapping_service.dart';

/// Custom TextInputFormatter that converts English keyboard input
/// to Indian script characters using Anu Script Manager layout
class AnuScriptInputFormatter extends TextInputFormatter {
  final String languageCode;
  final KeyboardMappingService _keyboardService = KeyboardMappingService();
  
  // Track if we're in a special state (like after H link key)
  String _pendingLinkKey = '';
  
  AnuScriptInputFormatter({required this.languageCode}) {
    _keyboardService.setLanguage(languageCode);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If text was deleted, just return the new value
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    
    // If no change or cursor moved without typing
    if (newValue.text == oldValue.text) {
      return newValue;
    }
    
    // Find what was typed
    final oldText = oldValue.text;
    final newText = newValue.text;
    final cursorPos = newValue.selection.baseOffset;
    
    // Find the insertion point
    int insertStart = 0;
    for (int i = 0; i < oldText.length && i < newText.length; i++) {
      if (oldText[i] != newText[i]) break;
      insertStart = i + 1;
    }
    
    // Get the newly typed characters
    final insertedLength = newText.length - oldText.length;
    if (insertedLength <= 0 || insertStart + insertedLength > newText.length) {
      return newValue;
    }
    
    final insertedText = newText.substring(insertStart, insertStart + insertedLength);
    
    // Convert the inserted text
    final convertedText = _convertText(insertedText);
    
    // If no conversion needed, return original
    if (convertedText == insertedText) {
      return newValue;
    }
    
    // Build the new text with converted characters
    final resultText = oldText.substring(0, insertStart) + 
                       convertedText + 
                       oldText.substring(insertStart);
    
    // Calculate new cursor position
    final newCursorPos = insertStart + convertedText.length;
    
    return TextEditingValue(
      text: resultText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }
  
  String _convertText(String input) {
    if (languageCode == 'en') return input;
    
    final buffer = StringBuffer();
    
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      final upperChar = char.toUpperCase();
      final isShift = char == upperChar && char.toLowerCase() != char;
      
      // Handle link key (H)
      if (_pendingLinkKey.isNotEmpty) {
        final halantChar = _getHalantCombo(upperChar, isShift);
        if (halantChar != null) {
          buffer.write(halantChar);
          _pendingLinkKey = '';
          continue;
        }
        _pendingLinkKey = '';
      }
      
      // Check if this is the link key
      if (upperChar == 'H' && !isShift) {
        _pendingLinkKey = 'H';
        continue;
      }
      
      // Get the mapped character
      final mappedChar = _keyboardService.getCharacterForKey(upperChar, isShift);
      
      if (mappedChar != null && mappedChar.isNotEmpty) {
        buffer.write(mappedChar);
      } else {
        buffer.write(char);
      }
    }
    
    return buffer.toString();
  }
  
  String? _getHalantCombo(String key, bool withShift) {
    // Get halant combinations based on language
    switch (languageCode) {
      case 'te':
        return _teluguHalantMap[withShift ? '^$key' : key];
      case 'hi':
        return _hindiHalantMap[withShift ? '^$key' : key];
      case 'ta':
        return _tamilHalantMap[withShift ? '^$key' : key];
      case 'kn':
        return _kannadaHalantMap[withShift ? '^$key' : key];
      case 'ml':
        return _malayalamHalantMap[withShift ? '^$key' : key];
      case 'bn':
        return _bengaliHalantMap[withShift ? '^$key' : key];
      default:
        return null;
    }
  }
  
  // Telugu halant (virama) combinations
  static const Map<String, String> _teluguHalantMap = {
    'J': 'క్', 'X': 'గ్', 'M': 'చ్', '/': 'జ్',
    'Z': 'ట్', 'C': 'డ్', 'S': 'త్', 'D': 'ద్',
    'L': 'న్', ';': 'ప్', 'V': 'బ్', 'B': 'మ్',
    'N': 'య్', 'K': 'ర్', 'A': 'ల్', 'F': 'వ్',
    '\'': 'స్',
    '^J': 'ఖ్', '^X': 'ఘ్', '^M': 'ఛ్', '^/': 'ఝ్',
    '^Z': 'ఠ్', '^C': 'ఢ్', '^S': 'థ్', '^D': 'ధ్',
    '^L': 'ణ్', '^;': 'ఫ్', '^V': 'భ్', '^F': 'శ్',
    '^\'': 'ష్', '^B': 'హ్', '^A': 'ళ్',
  };
  
  static const Map<String, String> _hindiHalantMap = {
    'J': 'क्', 'X': 'ग्', 'M': 'च्', '/': 'ज्',
    'Z': 'ट्', 'C': 'ड्', 'S': 'त्', 'D': 'द्',
    'L': 'न्', ';': 'प्', 'V': 'ब्', 'B': 'म्',
    'N': 'य्', 'K': 'र्', 'A': 'ल्', 'F': 'व्',
    '\'': 'स्',
  };
  
  static const Map<String, String> _tamilHalantMap = {
    'J': 'க்', 'X': 'ங்', 'M': 'ச்', '/': 'ஜ்',
    'Z': 'ட்', 'C': 'ண்', 'S': 'த்', 'D': 'ந்',
    'L': 'ன்', ';': 'ப்', 'V': 'ம்', 'B': 'ய்',
    'N': 'ர்', 'K': 'ல்', 'A': 'ள்', 'F': 'வ்',
  };
  
  static const Map<String, String> _kannadaHalantMap = {
    'J': 'ಕ್', 'X': 'ಗ್', 'M': 'ಚ್', '/': 'ಜ್',
    'Z': 'ಟ್', 'C': 'ಡ್', 'S': 'ತ್', 'D': 'ದ್',
    'L': 'ನ್', ';': 'ಪ್', 'V': 'ಬ್', 'B': 'ಮ್',
    'N': 'ಯ್', 'K': 'ರ್', 'A': 'ಲ್', 'F': 'ವ್',
    '\'': 'ಸ್',
  };
  
  static const Map<String, String> _malayalamHalantMap = {
    'J': 'ക്', 'X': 'ഗ്', 'M': 'ച്', '/': 'ജ്',
    'Z': 'ട്', 'C': 'ഡ്', 'S': 'ത്', 'D': 'ദ്',
    'L': 'ന്', ';': 'പ്', 'V': 'ബ്', 'B': 'മ്',
    'N': 'യ്', 'K': 'ര്', 'A': 'ല്', 'F': 'വ്',
    '\'': 'സ്',
  };
  
  static const Map<String, String> _bengaliHalantMap = {
    'J': 'ক্', 'X': 'গ্', 'M': 'চ্', '/': 'জ্',
    'Z': 'ট্', 'C': 'ড্', 'S': 'ত্', 'D': 'দ্',
    'L': 'ন্', ';': 'প্', 'V': 'ব্', 'B': 'ম্',
    'N': 'য্', 'K': 'র্', 'A': 'ল্', 'F': 'শ্',
    '\'': 'স্',
  };
}

/// Simple formatter that converts individual characters
class SimpleAnuScriptFormatter extends TextInputFormatter {
  final String languageCode;
  final KeyboardMappingService _keyboardService = KeyboardMappingService();
  
  SimpleAnuScriptFormatter({required this.languageCode}) {
    _keyboardService.setLanguage(languageCode);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Skip if English or deleting
    if (languageCode == 'en' || newValue.text.length <= oldValue.text.length) {
      return newValue;
    }
    
    // Find newly typed character
    if (newValue.text.length == oldValue.text.length + 1) {
      final cursorPos = newValue.selection.baseOffset;
      if (cursorPos > 0 && cursorPos <= newValue.text.length) {
        final newChar = newValue.text[cursorPos - 1];
        final upperChar = newChar.toUpperCase();
        final isShift = newChar == upperChar && 
                       newChar.toLowerCase() != newChar &&
                       RegExp(r'[A-Z]').hasMatch(newChar);
        
        // Get mapped character
        final mappedChar = _keyboardService.getCharacterForKey(upperChar, isShift);
        
        if (mappedChar != null && mappedChar.isNotEmpty && mappedChar != newChar) {
          // Replace the character
          final newText = newValue.text.substring(0, cursorPos - 1) +
                         mappedChar +
                         newValue.text.substring(cursorPos);
          
          return TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(
              offset: cursorPos - 1 + mappedChar.length,
            ),
          );
        }
      }
    }
    
    return newValue;
  }
}

