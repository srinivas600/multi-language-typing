import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/language_provider.dart';
import '../providers/learning_provider.dart';
import '../models/lesson_model.dart';
import '../widgets/custom_keyboard.dart';
import '../theme/app_theme.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final learnProvider = Provider.of<LearningProvider>(context);
    final lessons = learnProvider.getLessonsForLanguage(langProvider.currentLanguage);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          learnProvider.currentLesson == null 
              ? 'Learning - ${langProvider.currentLanguage.name}'
              : learnProvider.currentLesson!.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_1),
          onPressed: () {
            if (learnProvider.currentLesson != null) {
              learnProvider.clearLesson();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          if (learnProvider.currentLesson == null)
            Expanded(child: _buildLessonList(lessons))
          else
            Expanded(child: _buildPracticeArea(learnProvider)),
          
          if (learnProvider.currentLesson != null)
            CustomKeyboard(
              onCharacterTap: (char) {
                final currentContent = learnProvider.currentLesson!.content;
                if (learnProvider.typedText.length < currentContent.length) {
                  final expectedChar = currentContent[learnProvider.typedText.length];
                  learnProvider.onCharTyped(char, expectedChar);
                }
              },
              onBackspace: () {},
              onSpace: () {
                final currentContent = learnProvider.currentLesson!.content;
                if (learnProvider.typedText.length < currentContent.length) {
                  final expectedChar = currentContent[learnProvider.typedText.length];
                  learnProvider.onCharTyped(' ', expectedChar);
                }
              },
              onEnter: () {},
              onLanguageSwitch: () {},
            ),
        ],
      ),
    );
  }

  Widget _buildLessonList(List<Lesson> lessons) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return Card(
          color: AppTheme.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => context.read<LearningProvider>().startLesson(lesson),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Iconsax.book_1, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lesson.category,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Iconsax.arrow_right_3, color: Colors.white24, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPracticeArea(LearningProvider provider) {
    final lesson = provider.currentLesson!;
    final typedText = provider.typedText;
    final targetText = lesson.content;
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStats(provider),
          const SizedBox(height: 60),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 16,
              children: [
                for (int i = 0; i < targetText.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: i == typedText.length 
                              ? Colors.blue 
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      targetText[i],
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: langProvider.currentLanguage.fontFamily,
                        color: i < typedText.length
                            ? Colors.green
                            : i == typedText.length
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          if (provider.isCompleted)
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.tick_circle, color: Colors.green, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Great Job!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => provider.reset(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Try Again'),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => provider.clearLesson(),
                          child: const Text('All Lessons'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStats(LearningProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('WPM', provider.wpm.toString()),
          _statItem('ACCURACY', '${provider.accuracy.toStringAsFixed(0)}%'),
          _statItem('ERRORS', provider.errors.toString()),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
