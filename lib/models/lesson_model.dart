import '../models/language_model.dart';

class Lesson {
  final String id;
  final String title;
  final String category;
  final String content;
  final String languageCode;
  final int difficulty; // 1-5

  const Lesson({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.languageCode,
    this.difficulty = 1,
  });

  static List<Lesson> getLessonsForLanguage(IndianLanguage language) {
    switch (language.code) {
      case 'hi':
        return _hindiLessons;
      case 'te':
        return _teluguLessons;
      case 'ta':
        return _tamilLessons;
      case 'bn':
        return _bengaliLessons;
      default:
        return _defaultLessons(language.code);
    }
  }
}

const List<Lesson> _hindiLessons = [
  Lesson(
    id: 'hi_vowels',
    title: 'स्वर (Vowels)',
    category: 'Basic',
    content: 'अ आ इ ई उ ऊ',
    languageCode: 'hi',
    difficulty: 1,
  ),
  Lesson(
    id: 'hi_consonants_1',
    title: 'व्यंजन भाग 1',
    category: 'Basic',
    content: 'क ख ग घ ङ',
    languageCode: 'hi',
    difficulty: 1,
  ),
  Lesson(
    id: 'hi_consonants_2',
    title: 'व्यंजन भाग 2',
    category: 'Basic',
    content: 'च छ ज झ ञ',
    languageCode: 'hi',
    difficulty: 1,
  ),
  Lesson(
    id: 'hi_words_1',
    title: 'सरल शब्द',
    category: 'Words',
    content: 'कमल नमक',
    languageCode: 'hi',
    difficulty: 2,
  ),
  Lesson(
    id: 'hi_sentence_1',
    title: 'वाक्य अभ्यास',
    category: 'Sentences',
    content: 'राम घर जाता है',
    languageCode: 'hi',
    difficulty: 3,
  ),
];

const List<Lesson> _teluguLessons = [
  Lesson(
    id: 'te_vowels',
    title: 'అచ్చులు (Vowels)',
    category: 'Basic',
    content: 'అ ఆ ఇ ఈ ఉ ఊ',
    languageCode: 'te',
    difficulty: 1,
  ),
  Lesson(
    id: 'te_consonants_1',
    title: 'హల్లులు భాగం 1',
    category: 'Basic',
    content: 'క ఖ గ ఘ ఙ',
    languageCode: 'te',
    difficulty: 1,
  ),
  Lesson(
    id: 'te_words_1',
    title: 'సరళ పదాలు',
    category: 'Words',
    content: 'కమలం నీరు',
    languageCode: 'te',
    difficulty: 2,
  ),
];

const List<Lesson> _tamilLessons = [
  Lesson(
    id: 'ta_vowels',
    title: 'உயிர் (Vowels)',
    category: 'Basic',
    content: 'அ ஆ இ ஈ உ ஊ',
    languageCode: 'ta',
    difficulty: 1,
  ),
  Lesson(
    id: 'ta_consonants_1',
    title: 'மெய் பகுதி 1',
    category: 'Basic',
    content: 'க ங ச ஞ ட',
    languageCode: 'ta',
    difficulty: 1,
  ),
];

const List<Lesson> _bengaliLessons = [
  Lesson(
    id: 'bn_vowels',
    title: 'স্বরবর্ণ (Vowels)',
    category: 'Basic',
    content: 'অ আ ই ঈ উ ঊ',
    languageCode: 'bn',
    difficulty: 1,
  ),
  Lesson(
    id: 'bn_consonants_1',
    title: 'ব্যঞ্জনবর্ণ পার্ট 1',
    category: 'Basic',
    content: 'ক খ গ ঘ ঙ',
    languageCode: 'bn',
    difficulty: 1,
  ),
];

List<Lesson> _defaultLessons(String languageCode) {
  return [
    Lesson(
      id: '${languageCode}_basic',
      title: 'Basic Characters',
      category: 'Basic',
      content: 'Practice typing',
      languageCode: languageCode,
      difficulty: 1,
    ),
  ];
}
