import 'package:flutter/material.dart';

class IndianLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String fontFamily;
  final String script;
  final List<String> sampleCharacters;
  final Map<String, String> keyboardLayout;
  final Color themeColor;

  const IndianLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.fontFamily,
    required this.script,
    required this.sampleCharacters,
    required this.keyboardLayout,
    required this.themeColor,
  });

  static const List<IndianLanguage> supportedLanguages = [
    IndianLanguage(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      fontFamily: 'NotoSansDevanagari',
      script: 'Devanagari',
      sampleCharacters: ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ए', 'ऐ', 'ओ', 'औ'],
      keyboardLayout: _hindiKeyboard,
      themeColor: Color(0xFFFF9933),
    ),
    IndianLanguage(
      code: 'te',
      name: 'Telugu',
      nativeName: 'తెలుగు',
      fontFamily: 'NotoSansTelugu',
      script: 'Telugu',
      sampleCharacters: ['అ', 'ఆ', 'ఇ', 'ఈ', 'ఉ', 'ఊ', 'ఎ', 'ఏ', 'ఐ', 'ఒ'],
      keyboardLayout: _teluguKeyboard,
      themeColor: Color(0xFFE91E63),
    ),
    IndianLanguage(
      code: 'ta',
      name: 'Tamil',
      nativeName: 'தமிழ்',
      fontFamily: 'NotoSansTamil',
      script: 'Tamil',
      sampleCharacters: ['அ', 'ஆ', 'இ', 'ஈ', 'உ', 'ஊ', 'எ', 'ஏ', 'ஐ', 'ஒ'],
      keyboardLayout: _tamilKeyboard,
      themeColor: Color(0xFF9C27B0),
    ),
    IndianLanguage(
      code: 'ml',
      name: 'Malayalam',
      nativeName: 'മലയാളം',
      fontFamily: 'NotoSansMalayalam',
      script: 'Malayalam',
      sampleCharacters: ['അ', 'ആ', 'ഇ', 'ഈ', 'ഉ', 'ഊ', 'എ', 'ഏ', 'ഐ', 'ഒ'],
      keyboardLayout: _malayalamKeyboard,
      themeColor: Color(0xFF4CAF50),
    ),
    IndianLanguage(
      code: 'kn',
      name: 'Kannada',
      nativeName: 'ಕನ್ನಡ',
      fontFamily: 'NotoSansKannada',
      script: 'Kannada',
      sampleCharacters: ['ಅ', 'ಆ', 'ಇ', 'ಈ', 'ಉ', 'ಊ', 'ಎ', 'ಏ', 'ಐ', 'ಒ'],
      keyboardLayout: _kannadaKeyboard,
      themeColor: Color(0xFFFF5722),
    ),
    IndianLanguage(
      code: 'bn',
      name: 'Bengali',
      nativeName: 'বাংলা',
      fontFamily: 'NotoSansBengali',
      script: 'Bengali',
      sampleCharacters: ['অ', 'আ', 'ই', 'ঈ', 'উ', 'ঊ', 'এ', 'ঐ', 'ও', 'ঔ'],
      keyboardLayout: _bengaliKeyboard,
      themeColor: Color(0xFF2196F3),
    ),
    IndianLanguage(
      code: 'mr',
      name: 'Marathi',
      nativeName: 'मराठी',
      fontFamily: 'NotoSansDevanagari',
      script: 'Devanagari',
      sampleCharacters: ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ए', 'ऐ', 'ओ', 'औ'],
      keyboardLayout: _hindiKeyboard,
      themeColor: Color(0xFF795548),
    ),
    IndianLanguage(
      code: 'gu',
      name: 'Gujarati',
      nativeName: 'ગુજરાતી',
      fontFamily: 'NotoSansGujarati',
      script: 'Gujarati',
      sampleCharacters: ['અ', 'આ', 'ઇ', 'ઈ', 'ઉ', 'ઊ', 'એ', 'ઐ', 'ઓ', 'ઔ'],
      keyboardLayout: _gujaratiKeyboard,
      themeColor: Color(0xFF00BCD4),
    ),
    IndianLanguage(
      code: 'pa',
      name: 'Punjabi',
      nativeName: 'ਪੰਜਾਬੀ',
      fontFamily: 'NotoSansGurmukhi',
      script: 'Gurmukhi',
      sampleCharacters: ['ਅ', 'ਆ', 'ਇ', 'ਈ', 'ਉ', 'ਊ', 'ਏ', 'ਐ', 'ਓ', 'ਔ'],
      keyboardLayout: _punjabiKeyboard,
      themeColor: Color(0xFFFF9800),
    ),
    IndianLanguage(
      code: 'or',
      name: 'Odia',
      nativeName: 'ଓଡ଼ିଆ',
      fontFamily: 'NotoSansOriya',
      script: 'Oriya',
      sampleCharacters: ['ଅ', 'ଆ', 'ଇ', 'ଈ', 'ଉ', 'ଊ', 'ଏ', 'ଐ', 'ଓ', 'ଔ'],
      keyboardLayout: _odiaKeyboard,
      themeColor: Color(0xFF607D8B),
    ),
    IndianLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      fontFamily: 'Poppins',
      script: 'Latin',
      sampleCharacters: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'],
      keyboardLayout: _englishKeyboard,
      themeColor: Color(0xFF3F51B5),
    ),
  ];

  static IndianLanguage getByCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => supportedLanguages.first,
    );
  }
}

// Keyboard layouts for each language
const Map<String, String> _hindiKeyboard = {
  'row1': 'ौैाीूबहगदजड़',
  'row2': 'ोेािुपरकतचट',
  'row3': 'ंमनवलसयशष',
  'row4': 'abortzxcv',
  'vowels': 'अआइईउऊऋएऐओऔअं',
  'consonants': 'कखगघङचछजझञटठडढणतथदधनपफबभमयरलवशषसह',
  'matras': 'ािीुूृेैोौंः',
  'numbers': '०१२३४५६७८९',
  'special': '।॥ॐ₹',
};

const Map<String, String> _teluguKeyboard = {
  'row1': 'ౌైావీూబహగదజడ',
  'row2': 'ోేాిుపరకతచట',
  'row3': 'ంమనవలసయశష',
  'vowels': 'అఆఇఈఉఊఋఎఏఐఒఓఔ',
  'consonants': 'కఖగఘఙచఛజఝఞటఠడఢణతథదధనపఫబభమయరలవశషసహళ',
  'matras': 'ాిీుూృేైొోౌంః',
  'numbers': '౦౧౨౩౪౫౬౭౮౯',
  'special': '।॥ॐ₹',
};

const Map<String, String> _tamilKeyboard = {
  'row1': 'ௌைாீூபஹகதஜ',
  'row2': 'ோோிுபரகதசட',
  'row3': 'ம்னவலஸயஷஶ',
  'vowels': 'அஆஇஈஉஊஎஏஐஒஓஔ',
  'consonants': 'கஙசஞடணதநபமயரலவழளறன',
  'matras': 'ாிீுூெேைொோௌ்',
  'numbers': '௦௧௨௩௪௫௬௭௮௯',
  'special': '।॥ॐ₹',
};

const Map<String, String> _malayalamKeyboard = {
  'row1': 'ൗൈാീൂബഹഗദജഡ',
  'row2': 'ോോിുപരകതചട',
  'row3': 'ംമനവലസയശഷ',
  'vowels': 'അആഇഈഉഊഋഎഏഐഒഓഔ',
  'consonants': 'കഖഗഘങചഛജഝഞടഠഡഢണതഥദധനപഫബഭമയരലവശഷസഹളഴറ',
  'matras': 'ാിീുൂൃെേൈൊോൗംഃ',
  'numbers': '൦൧൨൩൪൫൬൭൮൯',
  'special': '।॥ॐ₹',
};

const Map<String, String> _kannadaKeyboard = {
  'row1': 'ೌೈಾೀೂಬಹಗದಜಡ',
  'row2': 'ೋೇಾಿುಪರಕತಚಟ',
  'row3': 'ಂಮನವಲಸಯಶಷ',
  'vowels': 'ಅಆಇಈಉಊಋಎಏಐಒಓಔ',
  'consonants': 'ಕಖಗಘಙಚಛಜಝಞಟಠಡಢಣತಥದಧನಪಫಬಭಮಯರಲವಶಷಸಹಳ',
  'matras': 'ಾಿೀುೂೃೆೇೈೊೋೌಂಃ',
  'numbers': '೦೧೨೩೪೫೬೭೮೯',
  'special': '।॥ॐ₹',
};

const Map<String, String> _bengaliKeyboard = {
  'row1': 'ৌৈাীূবহগদজড',
  'row2': 'োোিুপরকতচট',
  'row3': 'ংমনবলসযশষ',
  'vowels': 'অআইঈউঊঋএঐওঔ',
  'consonants': 'কখগঘঙচছজঝঞটঠডঢণতথদধনপফবভমযরলশষসহড়ঢ়য়',
  'matras': 'ািীুূৃেৈোৌংঃ',
  'numbers': '০১২৩৪৫৬৭৮৯',
  'special': '।॥ॐ₹৳',
};

const Map<String, String> _gujaratiKeyboard = {
  'row1': 'ૌૈાીૂબહગદજડ',
  'row2': 'ોેાિુપરકતચટ',
  'row3': 'ંમનવલસયશષ',
  'vowels': 'અઆઇઈઉઊઋએઐઓઔ',
  'consonants': 'કખગઘઙચછજઝઞટઠડઢણતથદધનપફબભમયરલવશષસહળ',
  'matras': 'ાિીુૂૃેૈોૌંઃ',
  'numbers': '૦૧૨૩૪૫૬૭૮૯',
  'special': '।॥ॐ₹',
};

const Map<String, String> _punjabiKeyboard = {
  'row1': 'ੌੈਾੀੂਬਹਗਦਜਡ',
  'row2': 'ੋੇਾਿੁਪਰਕਤਚਟ',
  'row3': 'ਂਮਨਵਲਸਯਸ਼ਸ਼',
  'vowels': 'ਅਆਇਈਉਊਏਐਓਔ',
  'consonants': 'ਕਖਗਘਙਚਛਜਝਞਟਠਡਢਣਤਥਦਧਨਪਫਬਭਮਯਰਲਵਸ਼ਸਹ',
  'matras': 'ਾਿੀੁੂੇੈੋੌਂਃ',
  'numbers': '੦੧੨੩੪੫੬੭੮੯',
  'special': '।॥ੴ₹',
};

const Map<String, String> _odiaKeyboard = {
  'row1': 'ୌୈାୀୂବହଗଦଜଡ',
  'row2': 'ୋୋିୁପରକତଚଟ',
  'row3': 'ଂମନବଲସଯଶଷ',
  'vowels': 'ଅଆଇଈଉଊଋଏଐଓଔ',
  'consonants': 'କଖଗଘଙଚଛଜଝଞଟଠଡଢଣତଥଦଧନପଫବଭମଯରଲଵଶଷସହଳ',
  'matras': 'ାିୀୁୂୃେୈୋୌଂଃ',
  'numbers': '୦୧୨୩୪୫୬୭୮୯',
  'special': '।॥ॐ₹',
};

const Map<String, String> _englishKeyboard = {
  'row1': 'qwertyuiop',
  'row2': 'asdfghjkl',
  'row3': 'zxcvbnm',
  'vowels': 'AEIOU',
  'consonants': 'BCDFGHJKLMNPQRSTVWXYZ',
  'numbers': '0123456789',
  'special': '.,!?@#\$%&*',
};

