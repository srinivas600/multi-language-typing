import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

import '../providers/document_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../models/language_model.dart';
import '../widgets/custom_keyboard.dart';
import '../widgets/formatting_toolbar.dart';
import '../widgets/keyboard_layout_overlay.dart';
import '../services/keyboard_mapping_service.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> with TickerProviderStateMixin {
  late TextEditingController _textController;
  late TextEditingController _titleController;
  late FocusNode _textFocusNode;
  late FocusNode _titleFocusNode;
  late AnimationController _keyboardAnimController;
  late Animation<double> _keyboardAnimation;
  
  bool _isKeyboardVisible = true;
  bool _showFormatting = false;
  bool _useExternalKeyboard = false;
  bool _showKeyboardLayout = false;
  final KeyboardMappingService _keyboardService = KeyboardMappingService();
  
  // For external keyboard conversion
  String _previousText = '';
  bool _isConverting = false;
  
  @override
  void initState() {
    super.initState();
    
    final docProvider = context.read<DocumentProvider>();
    final initialContent = docProvider.currentDocument?.content ?? '';
    _textController = TextEditingController(text: initialContent);
    _previousText = initialContent;
    
    _titleController = TextEditingController(
      text: docProvider.currentDocument?.title ?? 'Untitled',
    );
    
    _textFocusNode = FocusNode();
    _titleFocusNode = FocusNode();
    
    _keyboardAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _keyboardAnimation = CurvedAnimation(
      parent: _keyboardAnimController,
      curve: Curves.easeOutCubic,
    );
    
    _keyboardAnimController.forward();
    
    // Listen to text changes
    _textController.addListener(_onTextChanged);
    _titleController.addListener(_onTitleChanged);
    
    // Set the language from document
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (docProvider.currentDocument != null) {
        final langCode = docProvider.currentDocument!.languageCode;
        context.read<LanguageProvider>().setLanguageByCode(langCode);
        _keyboardService.setLanguage(langCode);
      }
    });
  }
  
  /// Handle external keyboard input
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_useExternalKeyboard) return KeyEventResult.ignored;
    
    // Update shift state
    if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
        event.logicalKey == LogicalKeyboardKey.shiftRight) {
      if (event is KeyDownEvent) {
        _keyboardService.setShiftState(true);
      } else if (event is KeyUpEvent) {
        _keyboardService.setShiftState(false);
      }
      return KeyEventResult.handled;
    }
    
    // Handle backspace
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      _deleteCharacter();
      return KeyEventResult.handled;
    }
    
    // Handle enter
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      _insertCharacter('\n');
      return KeyEventResult.handled;
    }
    
    // Handle space
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      _insertCharacter(' ');
      return KeyEventResult.handled;
    }
    
    // Process other keys
    if (event is KeyDownEvent) {
      final keyLabel = event.logicalKey.keyLabel;
      if (keyLabel.isNotEmpty) {
        final langProvider = context.read<LanguageProvider>();
        _keyboardService.setLanguage(langProvider.currentLanguage.code);
        
        final isShift = HardwareKeyboard.instance.isShiftPressed;
        final mappedChar = _keyboardService.getCharacterForKey(keyLabel, isShift);
        
        if (mappedChar != null && mappedChar.isNotEmpty) {
          _insertCharacter(mappedChar);
          return KeyEventResult.handled;
        }
      }
    }
    
    return KeyEventResult.ignored;
  }
  
  void _onTextChanged() {
    // Auto-convert ASCII to Indian script when language is not English
    // This works for both external keyboard AND when toggle is enabled
    if (!_isConverting) {
      final currentText = _textController.text;
      final langProvider = context.read<LanguageProvider>();
      final langCode = langProvider.currentLanguage.code;
      
      // Only process if language is not English and text was added
      if (langCode != 'en' && currentText.length > _previousText.length) {
        
        final selection = _textController.selection;
        
        if (selection.isValid && selection.isCollapsed) {
          final cursorPos = selection.baseOffset;
          final addedLength = currentText.length - _previousText.length;
          
          if (cursorPos >= addedLength && addedLength > 0 && addedLength <= 5) {
            final startPos = cursorPos - addedLength;
            final addedText = currentText.substring(startPos, cursorPos);
            
            // Check if the added text contains ASCII letters to convert
            // This means it came from an external/physical keyboard
            if (_shouldConvert(addedText)) {
              _keyboardService.setLanguage(langCode);
              final convertedText = _convertToIndianScript(addedText);
              
              // Conversion happening: $addedText -> $convertedText
              
              if (convertedText != addedText) {
                _isConverting = true;
                
                final newText = currentText.substring(0, startPos) + 
                               convertedText + 
                               currentText.substring(cursorPos);
                final newCursorPos = startPos + convertedText.length;
                
                // Use Future.microtask to avoid issues with controller updates
                Future.microtask(() {
                  _textController.value = TextEditingValue(
                    text: newText,
                    selection: TextSelection.collapsed(offset: newCursorPos),
                  );
                  _previousText = newText;
                  _isConverting = false;
                });
                
                return;
              }
            }
          }
        }
      }
      _previousText = currentText;
    }
    
    context.read<DocumentProvider>().updateContent(_textController.text);
  }
  
  bool _shouldConvert(String text) {
    // Check if text contains ASCII letters that should be converted
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final code = char.codeUnitAt(0);
      // ASCII letters (A-Z, a-z) or special keys that map to characters
      if ((code >= 65 && code <= 90) || // A-Z
          (code >= 97 && code <= 122) || // a-z
          (code >= 48 && code <= 57) || // 0-9
          ";',./[]".contains(char)) {
        return true;
      }
    }
    return false;
  }
  
  String _convertToIndianScript(String input) {
    final buffer = StringBuffer();
    
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      
      // Skip spaces and newlines
      if (char == ' ' || char == '\n' || char == '\r' || char == '\t') {
        buffer.write(char);
        continue;
      }
      
      final upperChar = char.toUpperCase();
      // Check if shift was pressed (uppercase letter typed)
      final isShift = char == upperChar && 
                     char != char.toLowerCase() &&
                     RegExp(r'[A-Z]').hasMatch(char);
      
      final mappedChar = _keyboardService.getCharacterForKey(upperChar, isShift);
      
      if (mappedChar != null && mappedChar.isNotEmpty) {
        buffer.write(mappedChar);
      } else {
        // Keep character as-is if no mapping found
        buffer.write(char);
      }
    }
    
    return buffer.toString();
  }
  
  void _onTitleChanged() {
    context.read<DocumentProvider>().updateTitle(_titleController.text);
  }
  
  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _titleController.removeListener(_onTitleChanged);
    _textController.dispose();
    _titleController.dispose();
    _textFocusNode.dispose();
    _titleFocusNode.dispose();
    _keyboardAnimController.dispose();
    super.dispose();
  }
  
  void _insertCharacter(String char) {
    final text = _textController.text;
    final selection = _textController.selection;
    
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      char,
    );
    
    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + char.length,
      ),
    );
    
    // Haptic feedback
    HapticFeedback.lightImpact();
  }
  
  void _deleteCharacter() {
    final text = _textController.text;
    final selection = _textController.selection;
    
    if (selection.start == 0 && selection.end == 0) return;
    
    String newText;
    int newCursorPos;
    
    if (selection.start != selection.end) {
      // Delete selection
      newText = text.replaceRange(selection.start, selection.end, '');
      newCursorPos = selection.start;
    } else {
      // Delete character before cursor
      newText = text.replaceRange(selection.start - 1, selection.start, '');
      newCursorPos = selection.start - 1;
    }
    
    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
    
    HapticFeedback.lightImpact();
  }
  
  void _insertSpace() {
    _insertCharacter(' ');
  }
  
  void _insertNewLine() {
    _insertCharacter('\n');
  }
  
  void _toggleKeyboard() {
    setState(() {
      _isKeyboardVisible = !_isKeyboardVisible;
      if (_isKeyboardVisible) {
        _keyboardAnimController.forward();
      } else {
        _keyboardAnimController.reverse();
      }
    });
  }
  
  Future<void> _shareDocument() async {
    final doc = context.read<DocumentProvider>().currentDocument;
    if (doc == null) return;
    
    await Share.share(
      doc.content,
      subject: doc.title,
    );
  }
  
  Future<void> _exportToPDF() async {
    final doc = context.read<DocumentProvider>().currentDocument;
    if (doc == null) return;
    
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                doc.title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                doc.content,
                style: const pw.TextStyle(fontSize: 14),
              ),
            ],
          );
        },
      ),
    );
    
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
  
  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer<LanguageProvider>(
          builder: (context, langProvider, _) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.textMuted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Switch Language',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: IndianLanguage.supportedLanguages.length,
                      itemBuilder: (context, index) {
                        final lang = IndianLanguage.supportedLanguages[index];
                        final isSelected = langProvider.currentLanguage.code == lang.code;
                        
                        return GestureDetector(
                          onTap: () {
                            langProvider.setLanguage(lang);
                            context.read<DocumentProvider>().updateLanguage(lang.code);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? lang.themeColor.withValues(alpha: 0.2)
                                  : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected 
                                    ? lang.themeColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  lang.sampleCharacters.first,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: lang.themeColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lang.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isSelected 
                                        ? AppTheme.textLight
                                        : AppTheme.textMuted,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                icon: Iconsax.share,
                title: 'Share',
                subtitle: 'Share as text',
                onTap: () {
                  Navigator.pop(context);
                  _shareDocument();
                },
              ),
              _buildOptionTile(
                icon: Iconsax.document_download,
                title: 'Export PDF',
                subtitle: 'Save as PDF file',
                onTap: () {
                  Navigator.pop(context);
                  _exportToPDF();
                },
              ),
              _buildOptionTile(
                icon: Iconsax.copy,
                title: 'Copy All',
                subtitle: 'Copy to clipboard',
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _textController.text));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Copied to clipboard'),
                      backgroundColor: AppTheme.forestGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
              _buildOptionTile(
                icon: Iconsax.trash,
                title: 'Clear All',
                subtitle: 'Clear document content',
                color: AppTheme.rubyRed,
                onTap: () {
                  Navigator.pop(context);
                  _textController.clear();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (color ?? AppTheme.saffron).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color ?? AppTheme.saffron),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // App Bar
                  _buildAppBar(),
                  
                  // External Keyboard Mode Indicator
                  if (_useExternalKeyboard) _buildExternalKeyboardBanner(),
                  
                  // Title Field
                  _buildTitleField(),
                  
                  // Formatting Toolbar (optional)
                  if (_showFormatting) const FormattingToolbar(),
                  
                  // Text Editor
                  Expanded(
                    child: _buildTextEditor(),
                  ),
                  
                  // Custom Keyboard (only when not using external keyboard)
                  if (!_useExternalKeyboard)
                    SizeTransition(
                      sizeFactor: _keyboardAnimation,
                      axisAlignment: -1.0,
                      child: CustomKeyboard(
                        onCharacterTap: _insertCharacter,
                        onBackspace: _deleteCharacter,
                        onSpace: _insertSpace,
                        onEnter: _insertNewLine,
                        onLanguageSwitch: _showLanguageSelector,
                      ),
                    ),
                ],
              ),
              
              // Keyboard Layout Overlay
              if (_showKeyboardLayout)
                KeyboardLayoutOverlay(
                  languageCode: context.watch<LanguageProvider>().currentLanguage.code,
                  onClose: () => setState(() => _showKeyboardLayout = false),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildExternalKeyboardBanner() {
    final langProvider = context.watch<LanguageProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppTheme.forestGreen.withValues(alpha: 0.2),
      child: Row(
        children: [
          Icon(
            Iconsax.keyboard,
            size: 18,
            color: AppTheme.forestGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'External Keyboard: ${langProvider.currentLanguage.name} (Anu Script)',
              style: TextStyle(
                color: AppTheme.forestGreen,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showKeyboardLayout = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.forestGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'View Layout',
                style: TextStyle(
                  color: AppTheme.forestGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppBar() {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Iconsax.arrow_left),
              ),
              const Spacer(),
              // Language indicator
              GestureDetector(
                onTap: _showLanguageSelector,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: langProvider.currentLanguage.themeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: langProvider.currentLanguage.themeColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        langProvider.currentLanguage.sampleCharacters.first,
                        style: TextStyle(
                          color: langProvider.currentLanguage.themeColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        langProvider.currentLanguage.name,
                        style: TextStyle(
                          color: langProvider.currentLanguage.themeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Iconsax.arrow_down_1,
                        size: 14,
                        color: langProvider.currentLanguage.themeColor,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // External Keyboard Toggle - Made more visible
              GestureDetector(
                onTap: () {
                  setState(() {
                    _useExternalKeyboard = !_useExternalKeyboard;
                    // Reset previous text tracking when toggling mode
                    _previousText = _textController.text;
                    if (_useExternalKeyboard) {
                      _isKeyboardVisible = false;
                      _keyboardAnimController.reverse();
                    }
                  });
                  if (_useExternalKeyboard) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Iconsax.keyboard, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text('External Keyboard: ${langProvider.currentLanguage.name}'),
                          ],
                        ),
                        backgroundColor: AppTheme.forestGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _useExternalKeyboard 
                        ? AppTheme.forestGreen.withValues(alpha: 0.2)
                        : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _useExternalKeyboard 
                          ? AppTheme.forestGreen 
                          : AppTheme.textMuted.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.keyboard,
                        size: 16,
                        color: _useExternalKeyboard ? AppTheme.forestGreen : AppTheme.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _useExternalKeyboard ? 'EXT' : 'KB',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _useExternalKeyboard ? AppTheme.forestGreen : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showFormatting = !_showFormatting;
                  });
                },
                icon: Icon(
                  Iconsax.text,
                  color: _showFormatting ? AppTheme.saffron : null,
                ),
              ),
              if (!_useExternalKeyboard)
                IconButton(
                  onPressed: _toggleKeyboard,
                  icon: Icon(
                    _isKeyboardVisible ? Iconsax.keyboard_open : Iconsax.keyboard,
                    color: _isKeyboardVisible ? AppTheme.saffron : null,
                  ),
                ),
              IconButton(
                onPressed: _showMoreOptions,
                icon: const Icon(Iconsax.more),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTitleField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          hintText: 'Document Title',
          border: InputBorder.none,
          filled: false,
        ),
        onTap: () {
          // Hide custom keyboard when editing title
          if (_isKeyboardVisible) {
            setState(() {
              _isKeyboardVisible = false;
              _keyboardAnimController.reverse();
            });
          }
        },
      ),
    );
  }
  
  Widget _buildTextEditor() {
    return Consumer2<LanguageProvider, DocumentProvider>(
      builder: (context, langProvider, docProvider, _) {
        final formatting = docProvider.currentFormatting;
        
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: langProvider.currentLanguage.themeColor.withValues(alpha: 0.2),
            ),
          ),
          child: TextField(
            controller: _textController,
            focusNode: _textFocusNode,
            maxLines: null,
            expands: true,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            style: TextStyle(
              fontFamily: langProvider.currentLanguage.fontFamily,
              fontSize: formatting.fontSize,
              fontWeight: formatting.bold ? FontWeight.bold : FontWeight.normal,
              fontStyle: formatting.italic ? FontStyle.italic : FontStyle.normal,
              decoration: formatting.underline ? TextDecoration.underline : null,
              color: AppTheme.textLight,
              height: 1.6,
            ),
            textAlign: _getTextAlign(formatting.alignment),
            decoration: InputDecoration(
              hintText: _useExternalKeyboard 
                  ? 'Type using external keyboard (Anu Script layout)...'
                  : 'Start typing in ${langProvider.currentLanguage.name}...',
              hintStyle: TextStyle(
                color: AppTheme.textMuted.withValues(alpha: 0.5),
                fontFamily: langProvider.currentLanguage.fontFamily,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
            onTap: () {
              // Show custom keyboard when tapping text field (only if not using external keyboard)
              if (!_isKeyboardVisible && !_useExternalKeyboard) {
                setState(() {
                  _isKeyboardVisible = true;
                  _keyboardAnimController.forward();
                });
              }
            },
          ),
        );
      },
    );
  }
  
  TextAlign _getTextAlign(String alignment) {
    switch (alignment) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }
}

