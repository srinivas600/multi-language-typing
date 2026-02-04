import 'package:flutter/material.dart';
import '../models/language_model.dart';
import '../theme/app_theme.dart';

class LanguageCard extends StatelessWidget {
  final IndianLanguage language;
  final bool isSelected;
  final VoidCallback onTap;
  
  const LanguageCard({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    language.themeColor.withValues(alpha: 0.3),
                    language.themeColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    AppTheme.cardDark,
                    AppTheme.cardDark.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? language.themeColor 
                : AppTheme.cardDark,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: language.themeColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Script sample
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: language.themeColor.withValues(alpha: isSelected ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                language.sampleCharacters.first,
                style: TextStyle(
                  fontSize: 24,
                  color: language.themeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Language name
            Text(
              language.name,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppTheme.textLight : AppTheme.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Native name
            Text(
              language.nativeName,
              style: TextStyle(
                fontSize: 10,
                color: isSelected 
                    ? language.themeColor.withValues(alpha: 0.8) 
                    : AppTheme.textMuted.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
