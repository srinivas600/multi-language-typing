import 'package:uuid/uuid.dart';

class Document {
  final String id;
  String title;
  String content;
  String languageCode;
  DateTime createdAt;
  DateTime updatedAt;
  Map<String, dynamic>? formatting;
  
  Document({
    String? id,
    required this.title,
    this.content = '',
    this.languageCode = 'hi',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.formatting,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();
  
  Document copyWith({
    String? title,
    String? content,
    String? languageCode,
    DateTime? updatedAt,
    Map<String, dynamic>? formatting,
  }) {
    return Document(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      languageCode: languageCode ?? this.languageCode,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      formatting: formatting ?? this.formatting,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'languageCode': languageCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'formatting': formatting,
    };
  }
  
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      title: json['title'],
      content: json['content'] ?? '',
      languageCode: json['languageCode'] ?? 'hi',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      formatting: json['formatting'],
    );
  }
  
  int get wordCount {
    if (content.isEmpty) return 0;
    return content.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }
  
  int get characterCount => content.length;
}

class TextFormatting {
  bool bold;
  bool italic;
  bool underline;
  double fontSize;
  String fontFamily;
  String? color;
  String alignment;
  
  TextFormatting({
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.fontSize = 18.0,
    this.fontFamily = 'NotoSansDevanagari',
    this.color,
    this.alignment = 'left',
  });
  
  TextFormatting copyWith({
    bool? bold,
    bool? italic,
    bool? underline,
    double? fontSize,
    String? fontFamily,
    String? color,
    String? alignment,
  }) {
    return TextFormatting(
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      underline: underline ?? this.underline,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment,
    );
  }
}

