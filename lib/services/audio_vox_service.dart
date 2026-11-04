import 'package:audioplayers/audioplayers.dart';

class AudioVoxService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playChime() async {
    try {
      await _audioPlayer.play(AssetSource('audio/cogitator_beep.mp3'));
    } catch (_) {}
  }

  Future<void> playStaticBurst() async {
    try {
      await _audioPlayer.play(AssetSource('audio/vox_static.mp3'));
    } catch (_) {}
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
