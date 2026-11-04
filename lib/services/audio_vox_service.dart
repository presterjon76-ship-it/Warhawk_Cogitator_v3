import 'package:flutter/services.dart';

class AudioVoxService {
  Future<void> playChime() async {
    await SystemSound.play(SystemSoundType.click);
    await HapticFeedback.mediumImpact();
  }

  Future<void> playStaticBurst() async {
    await HapticFeedback.heavyImpact();
  }

  void dispose() {}
}
