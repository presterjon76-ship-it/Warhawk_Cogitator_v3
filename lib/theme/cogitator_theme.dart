import 'package:flutter/material.dart';

class CogitatorTheme {
  static const Color crtGreen = Color(0xFF33FF33);
  static const Color crtGreenDim = Color(0xFF1B8A1B);
  static const Color crtAmber = Color(0xFFFFB000);
  static const Color rustRed = Color(0xFF6B1D1D);
  static const Color sanctifiedGold = Color(0xFFD4AF37);
  static const Color parchment = Color(0xFFE8DCB8);
  static const Color voidDark = Color(0xFF080C08);
  static const Color terminalBorder = Color(0xFF264026);

  static TextStyle get terminalText => const TextStyle(
    fontFamily: 'monospace',
    color: crtGreen,
    fontSize: 14.0,
    letterSpacing: 1.2,
    shadows: [
      Shadow(blurRadius: 4.0, color: crtGreen, offset: Offset(0, 0)),
    ],
  );

  static TextStyle get terminalHeader => const TextStyle(
    fontFamily: 'serif',
    color: sanctifiedGold,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
  );

  static TextStyle get terminalAlert => const TextStyle(
    fontFamily: 'monospace',
    color: crtAmber,
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );

  static BoxDecoration get cogitatorBoxDecoration => BoxDecoration(
    color: voidDark,
    border: Border.all(color: terminalBorder, width: 2.0),
    borderRadius: BorderRadius.circular(4.0),
  );
}
