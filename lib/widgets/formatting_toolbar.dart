import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/document_provider.dart';
import '../theme/app_theme.dart';

class FormattingToolbar extends StatelessWidget {
  const FormattingToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, docProvider, _) {
        final formatting = docProvider.currentFormatting;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.saffron.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Bold
                _FormatButton(
                  icon: Iconsax.text_bold,
                  isActive: formatting.bold,
                  onTap: () => docProvider.toggleBold(),
                ),
                const SizedBox(width: 4),
                // Italic
                _FormatButton(
                  icon: Iconsax.text_italic,
                  isActive: formatting.italic,
                  onTap: () => docProvider.toggleItalic(),
                ),
                const SizedBox(width: 4),
                // Underline
                _FormatButton(
                  icon: Iconsax.text_underline,
                  isActive: formatting.underline,
                  onTap: () => docProvider.toggleUnderline(),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 24,
                  color: AppTheme.textMuted.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 12),
                // Align Left
                _FormatButton(
                  icon: Iconsax.textalign_left,
                  isActive: formatting.alignment == 'left',
                  onTap: () => docProvider.setAlignment('left'),
                ),
                const SizedBox(width: 4),
                // Align Center
                _FormatButton(
                  icon: Iconsax.textalign_center,
                  isActive: formatting.alignment == 'center',
                  onTap: () => docProvider.setAlignment('center'),
                ),
                const SizedBox(width: 4),
                // Align Right
                _FormatButton(
                  icon: Iconsax.textalign_right,
                  isActive: formatting.alignment == 'right',
                  onTap: () => docProvider.setAlignment('right'),
                ),
                const SizedBox(width: 4),
                // Justify
                _FormatButton(
                  icon: Iconsax.textalign_justifycenter,
                  isActive: formatting.alignment == 'justify',
                  onTap: () => docProvider.setAlignment('justify'),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 24,
                  color: AppTheme.textMuted.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 12),
                // Font Size decrease
                _FormatButton(
                  icon: Iconsax.minus,
                  isActive: false,
                  onTap: () {
                    if (formatting.fontSize > 12) {
                      docProvider.setFontSize(formatting.fontSize - 2);
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${formatting.fontSize.toInt()}',
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Font Size increase
                _FormatButton(
                  icon: Iconsax.add,
                  isActive: false,
                  onTap: () {
                    if (formatting.fontSize < 48) {
                      docProvider.setFontSize(formatting.fontSize + 2);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FormatButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  
  const _FormatButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive 
              ? AppTheme.saffron.withValues(alpha: 0.2) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive 
                ? AppTheme.saffron 
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? AppTheme.saffron : AppTheme.textMuted,
        ),
      ),
    );
  }
}
