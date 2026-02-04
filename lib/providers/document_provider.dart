import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/document_model.dart';

class DocumentProvider extends ChangeNotifier {
  List<Document> _documents = [];
  Document? _currentDocument;
  TextFormatting _currentFormatting = TextFormatting();
  bool _isLoading = false;
  
  List<Document> get documents => _documents;
  Document? get currentDocument => _currentDocument;
  TextFormatting get currentFormatting => _currentFormatting;
  bool get isLoading => _isLoading;
  
  DocumentProvider() {
    _loadDocuments();
  }
  
  // Create a new document
  Document createDocument({String title = 'Untitled', String languageCode = 'hi'}) {
    final doc = Document(
      title: title,
      languageCode: languageCode,
    );
    _documents.insert(0, doc);
    _currentDocument = doc;
    _saveDocuments();
    notifyListeners();
    return doc;
  }
  
  // Open a document
  void openDocument(Document doc) {
    _currentDocument = doc;
    notifyListeners();
  }
  
  // Update current document content
  void updateContent(String content) {
    if (_currentDocument != null) {
      final index = _documents.indexWhere((d) => d.id == _currentDocument!.id);
      if (index != -1) {
        _documents[index] = _currentDocument!.copyWith(
          content: content,
          updatedAt: DateTime.now(),
        );
        _currentDocument = _documents[index];
        _saveDocuments();
        notifyListeners();
      }
    }
  }
  
  // Update document title
  void updateTitle(String title) {
    if (_currentDocument != null) {
      final index = _documents.indexWhere((d) => d.id == _currentDocument!.id);
      if (index != -1) {
        _documents[index] = _currentDocument!.copyWith(
          title: title,
          updatedAt: DateTime.now(),
        );
        _currentDocument = _documents[index];
        _saveDocuments();
        notifyListeners();
      }
    }
  }
  
  // Update document language
  void updateLanguage(String languageCode) {
    if (_currentDocument != null) {
      final index = _documents.indexWhere((d) => d.id == _currentDocument!.id);
      if (index != -1) {
        _documents[index] = _currentDocument!.copyWith(
          languageCode: languageCode,
          updatedAt: DateTime.now(),
        );
        _currentDocument = _documents[index];
        _saveDocuments();
        notifyListeners();
      }
    }
  }
  
  // Delete a document
  void deleteDocument(String id) {
    _documents.removeWhere((d) => d.id == id);
    if (_currentDocument?.id == id) {
      _currentDocument = _documents.isNotEmpty ? _documents.first : null;
    }
    _saveDocuments();
    notifyListeners();
  }
  
  // Duplicate a document
  Document duplicateDocument(Document doc) {
    final newDoc = Document(
      title: '${doc.title} (Copy)',
      content: doc.content,
      languageCode: doc.languageCode,
      formatting: doc.formatting,
    );
    _documents.insert(0, newDoc);
    _saveDocuments();
    notifyListeners();
    return newDoc;
  }
  
  // Update text formatting
  void updateFormatting(TextFormatting formatting) {
    _currentFormatting = formatting;
    notifyListeners();
  }
  
  void toggleBold() {
    _currentFormatting = _currentFormatting.copyWith(bold: !_currentFormatting.bold);
    notifyListeners();
  }
  
  void toggleItalic() {
    _currentFormatting = _currentFormatting.copyWith(italic: !_currentFormatting.italic);
    notifyListeners();
  }
  
  void toggleUnderline() {
    _currentFormatting = _currentFormatting.copyWith(underline: !_currentFormatting.underline);
    notifyListeners();
  }
  
  void setFontSize(double size) {
    _currentFormatting = _currentFormatting.copyWith(fontSize: size);
    notifyListeners();
  }
  
  void setFontFamily(String family) {
    _currentFormatting = _currentFormatting.copyWith(fontFamily: family);
    notifyListeners();
  }
  
  void setAlignment(String alignment) {
    _currentFormatting = _currentFormatting.copyWith(alignment: alignment);
    notifyListeners();
  }
  
  void setTextColor(String color) {
    _currentFormatting = _currentFormatting.copyWith(color: color);
    notifyListeners();
  }
  
  // Save documents to local storage
  Future<void> _saveDocuments() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/documents.json');
      final jsonData = _documents.map((d) => d.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      debugPrint('Error saving documents: $e');
    }
  }
  
  // Load documents from local storage
  Future<void> _loadDocuments() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/documents.json');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        _documents = jsonData.map((json) => Document.fromJson(json)).toList();
        
        // Sort by updated date
        _documents.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      }
    } catch (e) {
      debugPrint('Error loading documents: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Export document as text
  Future<String> exportAsText() async {
    if (_currentDocument == null) return '';
    return _currentDocument!.content;
  }
  
  // Get recent documents
  List<Document> get recentDocuments {
    return _documents.take(5).toList();
  }
  
  // Search documents
  List<Document> searchDocuments(String query) {
    if (query.isEmpty) return _documents;
    final lowerQuery = query.toLowerCase();
    return _documents.where((doc) {
      return doc.title.toLowerCase().contains(lowerQuery) ||
          doc.content.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

