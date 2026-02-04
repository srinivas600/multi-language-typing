import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme.dart';
import '../services/keyboard_mapping_service.dart';

/// Overlay showing the Anu Script Manager keyboard layout
class KeyboardLayoutOverlay extends StatefulWidget {
  final String languageCode;
  final VoidCallback onClose;

  const KeyboardLayoutOverlay({
    super.key,
    required this.languageCode,
    required this.onClose,
  });

  @override
  State<KeyboardLayoutOverlay> createState() => _KeyboardLayoutOverlayState();
}

class _KeyboardLayoutOverlayState extends State<KeyboardLayoutOverlay> {
  bool _showShiftLayout = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.9),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Toggle for Normal/Shift
            _buildToggle(),
            
            // Keyboard Layout
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildKeyboardLayout(),
              ),
            ),
            
            // Instructions
            _buildInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final languageName = _getLanguageName(widget.languageCode);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$languageName Keyboard Layout',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Anu Script Manager Layout',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Iconsax.close_circle, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showShiftLayout = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_showShiftLayout ? AppTheme.saffron : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Normal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_showShiftLayout ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showShiftLayout = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _showShiftLayout ? AppTheme.saffron : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Shift (^)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _showShiftLayout ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardLayout() {
    final keyboardService = KeyboardMappingService();
    final layout = keyboardService.getKeyboardLayout(widget.languageCode, _showShiftLayout);

    // Define the keyboard rows
    final rows = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '[', ']'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';', '\''],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '/'],
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ];

    return Column(
      children: [
        for (var row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((key) {
                final mappedChar = layout[key] ?? key;
                return _buildKey(key, mappedChar);
              }).toList(),
            ),
          ),
        
        const SizedBox(height: 16),
        
        // Special keys section
        _buildSpecialKeysSection(),
      ],
    );
  }

  Widget _buildKey(String englishKey, String mappedChar) {
    final bool hasMapping = mappedChar != englishKey && mappedChar.isNotEmpty;
    
    return Container(
      width: 32,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: hasMapping ? AppTheme.surfaceDark : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: hasMapping 
              ? AppTheme.saffron.withValues(alpha: 0.5)
              : AppTheme.textMuted.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mapped character (Indian script)
          Text(
            mappedChar,
            style: TextStyle(
              color: hasMapping ? AppTheme.saffron : AppTheme.textMuted,
              fontSize: hasMapping ? 18 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          // English key
          Text(
            englishKey,
            style: TextStyle(
              color: AppTheme.textMuted.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialKeysSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special Keys',
            style: TextStyle(
              color: AppTheme.saffron,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildSpecialKeyRow('H', 'Link Key - Press before consonant for halant (్)'),
          _buildSpecialKeyRow('G', 'Vowel Sign (ా matra)'),
          _buildSpecialKeyRow('Shift+G', 'Visarga (ః)'),
          _buildSpecialKeyRow('Shift+Q', 'Anusvara (ం)'),
          _buildSpecialKeyRow('Space', 'Space'),
          _buildSpecialKeyRow('Enter', 'New Line'),
        ],
      ),
    );
  }

  Widget _buildSpecialKeyRow(String key, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.textMuted.withValues(alpha: 0.3)),
            ),
            child: Text(
              key,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.surfaceDark,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Iconsax.info_circle, color: AppTheme.ashokChakraBlue, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Connect an external keyboard and start typing!',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Press Shift for aspirated consonants and vowel signs',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'te': return 'Telugu';
      case 'hi': return 'Hindi';
      case 'ta': return 'Tamil';
      case 'kn': return 'Kannada';
      case 'ml': return 'Malayalam';
      case 'bn': return 'Bengali';
      default: return 'Language';
    }
  }
}

