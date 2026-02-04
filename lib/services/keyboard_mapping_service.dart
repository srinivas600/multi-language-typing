import 'package:flutter/services.dart';

/// Anu Script Manager Keyboard Mapping Service
/// Maps physical keyboard keys to Indian language characters
/// Based on the official Anu Script Manager keyboard layout
class KeyboardMappingService {
  static final KeyboardMappingService _instance = KeyboardMappingService._internal();
  factory KeyboardMappingService() => _instance;
  KeyboardMappingService._internal();

  String _currentLanguage = 'te'; // Default Telugu
  bool _isShiftPressed = false;
  String _pendingLinkKey = ''; // For H link key combinations

  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
  }

  void setShiftState(bool isPressed) {
    _isShiftPressed = isPressed;
  }

  /// Process a key event and return the corresponding character
  String? processKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Check for Shift key
      if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
          event.logicalKey == LogicalKeyboardKey.shiftRight) {
        _isShiftPressed = true;
        return null;
      }

      // Get the character for the pressed key
      final keyLabel = event.logicalKey.keyLabel;
      return getCharacterForKey(keyLabel, _isShiftPressed);
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
          event.logicalKey == LogicalKeyboardKey.shiftRight) {
        _isShiftPressed = false;
      }
    }
    return null;
  }

  /// Get the mapped character for a key
  String? getCharacterForKey(String key, bool withShift) {
    switch (_currentLanguage) {
      case 'te':
        return _getTeluguCharacter(key, withShift);
      case 'hi':
        return _getHindiCharacter(key, withShift);
      case 'ta':
        return _getTamilCharacter(key, withShift);
      case 'kn':
        return _getKannadaCharacter(key, withShift);
      case 'ml':
        return _getMalayalamCharacter(key, withShift);
      case 'bn':
        return _getBengaliCharacter(key, withShift);
      default:
        return key; // Return as-is for English
    }
  }

  /// Telugu keyboard mapping (Anu Script Manager layout)
  String? _getTeluguCharacter(String key, bool withShift) {
    // Handle Link Key (H) combinations
    if (_pendingLinkKey.isNotEmpty) {
      final result = _getTeluguLinkKeyCombo(_pendingLinkKey, key, withShift);
      _pendingLinkKey = '';
      if (result != null) return result;
    }

    // Check if this is the Link Key
    if (key.toUpperCase() == 'H' && !withShift) {
      _pendingLinkKey = 'H';
      return null; // Wait for next key
    }

    final keyUpper = key.toUpperCase();

    if (withShift) {
      // Shift + Key combinations (^ in the layout)
      return _teluguShiftMap[keyUpper];
    } else {
      // Normal key press
      return _teluguNormalMap[keyUpper];
    }
  }

  /// Telugu Link Key (H) combinations for conjuncts
  String? _getTeluguLinkKeyCombo(String linkKey, String nextKey, bool withShift) {
    final combo = withShift ? '^$nextKey' : nextKey;
    return _teluguLinkCombos[combo.toUpperCase()];
  }

  // Telugu Normal Key Map (without Shift)
  static const Map<String, String> _teluguNormalMap = {
    // Vowels (అచ్చులు)
    'Q': 'అ',    // a
    'E': 'ఆ',    // aa
    'R': 'ఇ',    // i
    'W': 'ఈ',    // ii
    'I': 'ఉ',    // u
    'P': 'ఊ',    // uu
    'U': 'ఎ',    // e
    'O': 'ఏ',    // ee
    '[': 'ఐ',    // ai
    'T': 'ఒ',    // o
    'Y': 'ఓ',    // oo
    ']': 'ఔ',    // au

    // Consonants (హల్లులు)
    'J': 'క',    // ka
    'X': 'గ',    // ga
    'M': 'చ',    // cha
    '/': 'జ',    // ja
    'Z': 'ట',    // Ta
    'C': 'డ',    // Da
    'S': 'త',    // ta
    'D': 'ద',    // da
    'L': 'న',    // na
    ';': 'ప',    // pa
    'V': 'బ',    // ba
    'B': 'మ',    // ma
    'N': 'య',    // ya
    'K': 'ర',    // ra
    'A': 'ల',    // la
    'F': 'వ',    // va
    '\'': 'స',   // sa

    // Vowel signs (మాత్రలు)
    'G': 'ా',    // aa matra
    'H': '',     // Link key - handled separately
    
    // Numbers
    '1': '౧',
    '2': '౨',
    '3': '౩',
    '4': '౪',
    '5': '౫',
    '6': '౬',
    '7': '౭',
    '8': '౮',
    '9': '౯',
    '0': '౦',

    // Punctuation
    '.': '.',
    ',': ',',
    ' ': ' ',
  };

  // Telugu Shift Key Map (with Shift - ^ in layout)
  static const Map<String, String> _teluguShiftMap = {
    // Vowel signs with Shift
    'W': 'ు',    // u matra
    'E': 'ూ',    // uu matra
    
    // Aspirated consonants
    'J': 'ఖ',    // kha
    'X': 'ఘ',    // gha
    'T': 'ఙ',    // nga
    'M': 'ఛ',    // chha
    '/': 'ఝ',    // jha
    'R': 'ఞ',    // nya
    'Z': 'ఠ',    // Tha
    'C': 'ఢ',    // Dha
    'L': 'ణ',    // Na
    'S': 'థ',    // tha
    'D': 'ధ',    // dha
    ';': 'ఫ',    // pha
    'V': 'భ',    // bha
    'F': 'శ',    // sha
    '\'': 'ష',   // Sha
    'B': 'హ',    // ha
    'A': 'ళ',    // La
    'Y': 'క్ష',   // ksha
    'K': 'ఋ',    // Ru

    // Special vowel signs
    'G': 'ః',    // visarga (ah)
    'Q': 'ం',    // anusvara (am)
    
    // Other matras
    'U': 'ె',    // e matra
    'O': 'ే',    // ee matra
    'I': 'ై',    // ai matra
    'P': 'ొ',    // o matra
    '[': 'ో',    // oo matra
    ']': 'ౌ',    // au matra
  };

  // Telugu Link Key Combinations (H + key)
  static const Map<String, String> _teluguLinkCombos = {
    'J': 'క్',    // ka halant
    'X': 'గ్',    // ga halant
    'M': 'చ్',    // cha halant
    'Z': 'ట్',    // Ta halant
    'C': 'డ్',    // Da halant
    'S': 'త్',    // ta halant
    'D': 'ద్',    // da halant
    'L': 'న్',    // na halant
    ';': 'ప్',    // pa halant
    'V': 'బ్',    // ba halant
    'B': 'మ్',    // ma halant
    'N': 'య్',    // ya halant
    'K': 'ర్',    // ra halant
    'A': 'ల్',    // la halant
    'F': 'వ్',    // va halant
    '\'': 'స్',   // sa halant
    
    // Shift combinations with link key
    '^J': 'ఖ్',
    '^X': 'ఘ్',
    '^M': 'ఛ్',
    '^Z': 'ఠ్',
    '^C': 'ఢ్',
    '^S': 'థ్',
    '^D': 'ధ్',
    '^;': 'ఫ్',
    '^V': 'భ్',
    '^F': 'శ్',
    '^\'': 'ష్',
    '^B': 'హ్',
    '^A': 'ళ్',
  };

  /// Hindi keyboard mapping (Anu Script Manager layout)
  String? _getHindiCharacter(String key, bool withShift) {
    final keyUpper = key.toUpperCase();
    if (withShift) {
      return _hindiShiftMap[keyUpper];
    } else {
      return _hindiNormalMap[keyUpper];
    }
  }

  static const Map<String, String> _hindiNormalMap = {
    // Vowels
    'Q': 'अ',
    'E': 'आ',
    'R': 'इ',
    'W': 'ई',
    'I': 'उ',
    'P': 'ऊ',
    'U': 'ए',
    'O': 'ऐ',
    '[': 'ओ',
    'T': 'औ',
    'Y': 'ऋ',

    // Consonants
    'J': 'क',
    'X': 'ग',
    'M': 'च',
    '/': 'ज',
    'Z': 'ट',
    'C': 'ड',
    'S': 'त',
    'D': 'द',
    'L': 'न',
    ';': 'प',
    'V': 'ब',
    'B': 'म',
    'N': 'य',
    'K': 'र',
    'A': 'ल',
    'F': 'व',
    '\'': 'स',

    // Matras
    'G': 'ा',

    // Numbers
    '1': '१',
    '2': '२',
    '3': '३',
    '4': '४',
    '5': '५',
    '6': '६',
    '7': '७',
    '8': '८',
    '9': '९',
    '0': '०',

    ' ': ' ',
    '.': '।',
  };

  static const Map<String, String> _hindiShiftMap = {
    'J': 'ख',
    'X': 'घ',
    'T': 'ङ',
    'M': 'छ',
    '/': 'झ',
    'R': 'ञ',
    'Z': 'ठ',
    'C': 'ढ',
    'L': 'ण',
    'S': 'थ',
    'D': 'ध',
    ';': 'फ',
    'V': 'भ',
    'F': 'श',
    '\'': 'ष',
    'B': 'ह',
    'A': 'ळ',

    'W': 'ु',
    'E': 'ू',
    'U': 'े',
    'O': 'ै',
    'I': 'ो',
    'P': 'ौ',
    'G': 'ः',
    'Q': 'ं',
  };

  /// Tamil keyboard mapping
  String? _getTamilCharacter(String key, bool withShift) {
    final keyUpper = key.toUpperCase();
    if (withShift) {
      return _tamilShiftMap[keyUpper];
    } else {
      return _tamilNormalMap[keyUpper];
    }
  }

  static const Map<String, String> _tamilNormalMap = {
    'Q': 'அ',
    'E': 'ஆ',
    'R': 'இ',
    'W': 'ஈ',
    'I': 'உ',
    'P': 'ஊ',
    'U': 'எ',
    'O': 'ஏ',
    '[': 'ஐ',
    'T': 'ஒ',
    'Y': 'ஓ',
    ']': 'ஔ',

    'J': 'க',
    'X': 'ங',
    'M': 'ச',
    '/': 'ஜ',
    'Z': 'ட',
    'C': 'ண',
    'S': 'த',
    'D': 'ந',
    'L': 'ன',
    ';': 'ப',
    'V': 'ம',
    'B': 'ய',
    'N': 'ர',
    'K': 'ல',
    'A': 'ள',
    'F': 'வ',
    '\'': 'ழ',
    'H': 'ற',

    'G': 'ா',

    '1': '௧',
    '2': '௨',
    '3': '௩',
    '4': '௪',
    '5': '௫',
    '6': '௬',
    '7': '௭',
    '8': '௮',
    '9': '௯',
    '0': '௦',

    ' ': ' ',
  };

  static const Map<String, String> _tamilShiftMap = {
    'W': 'ு',
    'E': 'ூ',
    'U': 'ெ',
    'O': 'ே',
    'I': 'ை',
    'P': 'ொ',
    '[': 'ோ',
    ']': 'ௌ',
    'G': '்',
    'F': 'ஶ',
    '\'': 'ஷ',
    'B': 'ஹ',
  };

  /// Kannada keyboard mapping
  String? _getKannadaCharacter(String key, bool withShift) {
    final keyUpper = key.toUpperCase();
    if (withShift) {
      return _kannadaShiftMap[keyUpper];
    } else {
      return _kannadaNormalMap[keyUpper];
    }
  }

  static const Map<String, String> _kannadaNormalMap = {
    'Q': 'ಅ',
    'E': 'ಆ',
    'R': 'ಇ',
    'W': 'ಈ',
    'I': 'ಉ',
    'P': 'ಊ',
    'U': 'ಎ',
    'O': 'ಏ',
    '[': 'ಐ',
    'T': 'ಒ',
    'Y': 'ಓ',
    ']': 'ಔ',

    'J': 'ಕ',
    'X': 'ಗ',
    'M': 'ಚ',
    '/': 'ಜ',
    'Z': 'ಟ',
    'C': 'ಡ',
    'S': 'ತ',
    'D': 'ದ',
    'L': 'ನ',
    ';': 'ಪ',
    'V': 'ಬ',
    'B': 'ಮ',
    'N': 'ಯ',
    'K': 'ರ',
    'A': 'ಲ',
    'F': 'ವ',
    '\'': 'ಸ',

    'G': 'ಾ',

    '1': '೧',
    '2': '೨',
    '3': '೩',
    '4': '೪',
    '5': '೫',
    '6': '೬',
    '7': '೭',
    '8': '೮',
    '9': '೯',
    '0': '೦',

    ' ': ' ',
  };

  static const Map<String, String> _kannadaShiftMap = {
    'J': 'ಖ',
    'X': 'ಘ',
    'T': 'ಙ',
    'M': 'ಛ',
    '/': 'ಝ',
    'R': 'ಞ',
    'Z': 'ಠ',
    'C': 'ಢ',
    'L': 'ಣ',
    'S': 'ಥ',
    'D': 'ಧ',
    ';': 'ಫ',
    'V': 'ಭ',
    'F': 'ಶ',
    '\'': 'ಷ',
    'B': 'ಹ',
    'A': 'ಳ',
    'Y': 'ಕ್ಷ',
    'K': 'ಋ',

    'W': 'ು',
    'E': 'ೂ',
    'U': 'ೆ',
    'O': 'ೇ',
    'I': 'ೈ',
    'P': 'ೊ',
    '[': 'ೋ',
    ']': 'ೌ',
    'G': 'ಃ',
    'Q': 'ಂ',
  };

  /// Malayalam keyboard mapping
  String? _getMalayalamCharacter(String key, bool withShift) {
    final keyUpper = key.toUpperCase();
    if (withShift) {
      return _malayalamShiftMap[keyUpper];
    } else {
      return _malayalamNormalMap[keyUpper];
    }
  }

  static const Map<String, String> _malayalamNormalMap = {
    'Q': 'അ',
    'E': 'ആ',
    'R': 'ഇ',
    'W': 'ഈ',
    'I': 'ഉ',
    'P': 'ഊ',
    'U': 'എ',
    'O': 'ഏ',
    '[': 'ഐ',
    'T': 'ഒ',
    'Y': 'ഓ',
    ']': 'ഔ',

    'J': 'ക',
    'X': 'ഗ',
    'M': 'ച',
    '/': 'ജ',
    'Z': 'ട',
    'C': 'ഡ',
    'S': 'ത',
    'D': 'ദ',
    'L': 'ന',
    ';': 'പ',
    'V': 'ബ',
    'B': 'മ',
    'N': 'യ',
    'K': 'ര',
    'A': 'ല',
    'F': 'വ',
    '\'': 'സ',

    'G': 'ാ',

    '1': '൧',
    '2': '൨',
    '3': '൩',
    '4': '൪',
    '5': '൫',
    '6': '൬',
    '7': '൭',
    '8': '൮',
    '9': '൯',
    '0': '൦',

    ' ': ' ',
  };

  static const Map<String, String> _malayalamShiftMap = {
    'J': 'ഖ',
    'X': 'ഘ',
    'T': 'ങ',
    'M': 'ഛ',
    '/': 'ഝ',
    'R': 'ഞ',
    'Z': 'ഠ',
    'C': 'ഢ',
    'L': 'ണ',
    'S': 'ഥ',
    'D': 'ധ',
    ';': 'ഫ',
    'V': 'ഭ',
    'F': 'ശ',
    '\'': 'ഷ',
    'B': 'ഹ',
    'A': 'ള',
    'Y': 'ക്ഷ',
    'K': 'ഋ',

    'W': 'ു',
    'E': 'ൂ',
    'U': 'െ',
    'O': 'േ',
    'I': 'ൈ',
    'P': 'ൊ',
    '[': 'ോ',
    ']': 'ൗ',
    'G': 'ഃ',
    'Q': 'ം',
  };

  /// Bengali keyboard mapping
  String? _getBengaliCharacter(String key, bool withShift) {
    final keyUpper = key.toUpperCase();
    if (withShift) {
      return _bengaliShiftMap[keyUpper];
    } else {
      return _bengaliNormalMap[keyUpper];
    }
  }

  static const Map<String, String> _bengaliNormalMap = {
    'Q': 'অ',
    'E': 'আ',
    'R': 'ই',
    'W': 'ঈ',
    'I': 'উ',
    'P': 'ঊ',
    'U': 'এ',
    'O': 'ঐ',
    '[': 'ও',
    'T': 'ঔ',
    'Y': 'ঋ',

    'J': 'ক',
    'X': 'গ',
    'M': 'চ',
    '/': 'জ',
    'Z': 'ট',
    'C': 'ড',
    'S': 'ত',
    'D': 'দ',
    'L': 'ন',
    ';': 'প',
    'V': 'ব',
    'B': 'ম',
    'N': 'য',
    'K': 'র',
    'A': 'ল',
    'F': 'শ',
    '\'': 'স',

    'G': 'া',

    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
    '0': '০',

    ' ': ' ',
  };

  static const Map<String, String> _bengaliShiftMap = {
    'J': 'খ',
    'X': 'ঘ',
    'T': 'ঙ',
    'M': 'ছ',
    '/': 'ঝ',
    'R': 'ঞ',
    'Z': 'ঠ',
    'C': 'ঢ',
    'L': 'ণ',
    'S': 'থ',
    'D': 'ধ',
    ';': 'ফ',
    'V': 'ভ',
    'F': 'ষ',
    'B': 'হ',
    'A': 'ळ',

    'W': 'ু',
    'E': 'ূ',
    'U': 'ে',
    'O': 'ৈ',
    'I': 'ো',
    'P': 'ৌ',
    'G': 'ঃ',
    'Q': 'ং',
  };

  /// Get keyboard layout info for display
  Map<String, String> getKeyboardLayout(String languageCode, bool withShift) {
    switch (languageCode) {
      case 'te':
        return withShift ? _teluguShiftMap : _teluguNormalMap;
      case 'hi':
        return withShift ? _hindiShiftMap : _hindiNormalMap;
      case 'ta':
        return withShift ? _tamilShiftMap : _tamilNormalMap;
      case 'kn':
        return withShift ? _kannadaShiftMap : _kannadaNormalMap;
      case 'ml':
        return withShift ? _malayalamShiftMap : _malayalamNormalMap;
      case 'bn':
        return withShift ? _bengaliShiftMap : _bengaliNormalMap;
      default:
        return {};
    }
  }
}

