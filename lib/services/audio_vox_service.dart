import 'package:flutter/services.dart';

class AudioVoxService {
  Future<void> playChime() async {
    // Uses native Android system sound click/chime without third-party libraries
    await SystemSound.play(SystemSoundType.click);
    await HapticFeedback.mediumImpact();
  }

  Future<void> playStaticBurst() async {
    await HapticFeedback.heavyImpact();
  }

  void dispose() {}
}
