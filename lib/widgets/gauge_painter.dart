import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/cogitator_theme.dart';

class MechanicalDialGauge extends StatelessWidget {
  final String label;
  final double value;
  final String readout;

  const MechanicalDialGauge({
    super.key,
    required this.label,
    required this.value,
    required this.readout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 105,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F140F),
        border: Border.all(color: CogitatorTheme.terminalBorder),
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _DialPainter(value: value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              label,
              style: CogitatorTheme.terminalText.copyWith(fontSize: 9),
            ),
            Text(
              readout,
              style: CogitatorTheme.terminalText.copyWith(
                fontSize: 10,
                color: CogitatorTheme.crtAmber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  final double value;

  _DialPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    final arcPaint = Paint()
      ..color = CogitatorTheme.crtGreenDim
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    const startAngle = 0.75 * pi;
    const sweepTotalAngle = 1.5 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotalAngle,
      false,
      arcPaint,
    );

    final activePaint = Paint()
      ..color = CogitatorTheme.crtGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotalAngle * value.clamp(0.0, 1.0),
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DialPainter oldDelegate) => oldDelegate.value != value;
}
