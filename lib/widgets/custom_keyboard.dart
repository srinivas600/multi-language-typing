import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class CustomKeyboard extends StatefulWidget {
  final Function(String) onCharacterTap;
  final VoidCallback onBackspace;
  final VoidCallback onSpace;
  final VoidCallback onEnter;
  final VoidCallback onLanguageSwitch;
  
  const CustomKeyboard({
    super.key,
    required this.onCharacterTap,
    required this.onBackspace,
    required this.onSpace,
    required this.onEnter,
    required this.onLanguageSwitch,
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        final characters = langProvider.getCharactersForMode();
        final themeColor = langProvider.currentLanguage.themeColor;
        
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Mode switcher
              _buildModeSwitcher(langProvider, themeColor),
              
              // Character grid
              _buildCharacterGrid(characters, themeColor),
              
              // Bottom row with special keys
              _buildBottomRow(themeColor),
              
              // Safe area padding
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildModeSwitcher(LanguageProvider langProvider, Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Language switch button
          GestureDetector(
            onTap: widget.onLanguageSwitch,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    langProvider.currentLanguage.sampleCharacters.first,
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Iconsax.global,
                    size: 16,
                    color: themeColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Mode buttons
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: langProvider.availableModes.map((mode) {
                  final isSelected = langProvider.keyboardMode == mode;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () => langProvider.setKeyboardMode(mode),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? themeColor 
                              : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected 
                                ? themeColor 
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          langProvider.getModeDisplayName(mode),
                          style: TextStyle(
                            color: isSelected 
                                ? AppTheme.darkBackground 
                                : AppTheme.textLight,
                            fontWeight: isSelected 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCharacterGrid(String characters, Color themeColor) {
    final charList = characters.split('');
    
    // Determine columns based on character count
    int crossAxisCount = 10;
    if (charList.length <= 12) {
      crossAxisCount = 6;
    } else if (charList.length <= 20) {
      crossAxisCount = 8;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(maxHeight: 180),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.0,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: charList.length,
        itemBuilder: (context, index) {
          return _KeyButton(
            character: charList[index],
            themeColor: themeColor,
            onTap: () => widget.onCharacterTap(charList[index]),
          );
        },
      ),
    );
  }
  
  Widget _buildBottomRow(Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Backspace
          Expanded(
            flex: 1,
            child: _SpecialKeyButton(
              icon: Iconsax.arrow_left_2,
              onTap: widget.onBackspace,
              onLongPress: () {
                HapticFeedback.mediumImpact();
              },
              themeColor: themeColor,
            ),
          ),
          const SizedBox(width: 6),
          // Space bar
          Expanded(
            flex: 4,
            child: _SpecialKeyButton(
              label: 'Space',
              onTap: widget.onSpace,
              themeColor: themeColor,
            ),
          ),
          const SizedBox(width: 6),
          // Danda (।)
          Expanded(
            flex: 1,
            child: _SpecialKeyButton(
              label: '।',
              onTap: () => widget.onCharacterTap('।'),
              themeColor: themeColor,
            ),
          ),
          const SizedBox(width: 6),
          // Enter
          Expanded(
            flex: 1,
            child: _SpecialKeyButton(
              icon: Iconsax.arrow_right_3,
              label: '↵',
              onTap: widget.onEnter,
              themeColor: themeColor,
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyButton extends StatefulWidget {
  final String character;
  final Color themeColor;
  final VoidCallback onTap;
  
  const _KeyButton({
    required this.character,
    required this.themeColor,
    required this.onTap,
  });

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        HapticFeedback.selectionClick();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.themeColor.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.character,
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecialKeyButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color themeColor;
  final bool isPrimary;
  
  const _SpecialKeyButton({
    this.icon,
    this.label,
    required this.onTap,
    this.onLongPress,
    required this.themeColor,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      onLongPress: onLongPress,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isPrimary ? themeColor : AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isPrimary 
                  ? themeColor.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  color: isPrimary ? AppTheme.darkBackground : AppTheme.textLight,
                  size: 22,
                )
              : Text(
                  label ?? '',
                  style: TextStyle(
                    color: isPrimary ? AppTheme.darkBackground : AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
