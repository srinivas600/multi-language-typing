import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.darkBackground,
                AppTheme.surfaceDark,
                AppTheme.darkBackground,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CustomPaint(
            painter: _BackgroundPatternPainter(
              animation: _controller.value,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _BackgroundPatternPainter extends CustomPainter {
  final double animation;

  _BackgroundPatternPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw subtle geometric patterns inspired by Indian art
    _drawMandalaPattern(canvas, size, paint);
    _drawFloatingElements(canvas, size, paint);
  }

  void _drawMandalaPattern(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width * 0.8, size.height * 0.15);
    final maxRadius = size.width * 0.3;

    paint.color = AppTheme.saffron.withValues(alpha: 0.03);

    for (int i = 0; i < 6; i++) {
      final radius = maxRadius * (0.3 + i * 0.15);
      final rotation = animation * math.pi * 2 + i * math.pi / 6;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation * (i % 2 == 0 ? 1 : -1));

      // Draw petal pattern
      for (int j = 0; j < 12; j++) {
        final angle = j * math.pi / 6;
        final x1 = math.cos(angle) * radius * 0.5;
        final y1 = math.sin(angle) * radius * 0.5;
        final x2 = math.cos(angle) * radius;
        final y2 = math.sin(angle) * radius;

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }

      canvas.restore();
    }

    // Draw concentric circles
    for (int i = 1; i <= 5; i++) {
      paint.color = AppTheme.saffron.withValues(alpha: 0.02);
      canvas.drawCircle(center, maxRadius * i / 5, paint);
    }
  }

  void _drawFloatingElements(Canvas canvas, Size size, Paint paint) {
    // Draw floating Devanagari-inspired shapes
    final elements = [
      {'x': 0.1, 'y': 0.3, 'char': 'ॐ', 'color': AppTheme.saffron},
      {'x': 0.2, 'y': 0.7, 'char': '॥', 'color': AppTheme.ashokChakraBlue},
      {'x': 0.9, 'y': 0.5, 'char': '।', 'color': AppTheme.forestGreen},
      {'x': 0.85, 'y': 0.8, 'char': '॰', 'color': AppTheme.accentGold},
    ];

    for (final element in elements) {
      final x = element['x'] as double;
      final y = element['y'] as double;
      final color = element['color'] as Color;

      // Floating animation
      final floatOffset = math.sin(animation * math.pi * 2 + x * 10) * 10;

      final position = Offset(
        size.width * x,
        size.height * y + floatOffset,
      );

      // Draw glow
      paint
        ..style = PaintingStyle.fill
        ..color = color.withValues(alpha: 0.05);

      canvas.drawCircle(position, 30, paint);

      paint
        ..style = PaintingStyle.stroke
        ..color = color.withValues(alpha: 0.08);

      canvas.drawCircle(position, 20, paint);
    }

    // Draw subtle grid pattern
    paint
      ..style = PaintingStyle.stroke
      ..color = AppTheme.textMuted.withValues(alpha: 0.02)
      ..strokeWidth = 0.5;

    final gridSpacing = 50.0;
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPatternPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
