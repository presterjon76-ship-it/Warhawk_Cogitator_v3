import 'package:flutter/material.dart';

class CrtScreen extends StatelessWidget {
  final Widget child;

  const CrtScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: CrtScanlinePainter(),
            ),
          ),
        ),
      ],
    );
  }
}

class CrtScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scanlinePaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..strokeWidth = 1.0;

    for (double y = 0.0; y < size.height; y += 3.0) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanlinePaint);
    }

    final vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.95,
      colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
      stops: const [0.75, 1.0],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final vignettePaint = Paint()..shader = vignetteGradient.createShader(rect);
    canvas.drawRect(rect, vignettePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
