import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/cogitator_theme.dart';
import '../services/cogitator_api.dart';
import '../services/audio_vox_service.dart';
import '../widgets/cogitator_hud.dart';
import '../widgets/gauge_painter.dart';
import '../widgets/crt_screen.dart';

class CogitatorTerminalScreen extends StatefulWidget {
  final CogitatorApiClient apiClient;

  const CogitatorTerminalScreen({super.key, required this.apiClient});

  @override
  State<CogitatorTerminalScreen> createState() => _CogitatorTerminalScreenState();
}

class _CogitatorTerminalScreenState extends State<CogitatorTerminalScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _consoleLogs = [];
  final AudioVoxService _voxService = AudioVoxService();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  int _xp = 1420;
  String _rank = "Enginseer Prime";

  double _water = 2.0;
  double _protein = 120.0;
  int _kinetic = 45;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _appendLog("ADEPTUS MECHANICUS COGITATOR ONLINE.");
    _appendLog("LITURGIES LOADED. ENGAGE COMMUNION PROTOCOLS.");
  }

  void _appendLog(String text) {
    setState(() {
      _consoleLogs.add("[${DateTime.now().toIso8601String().substring(11, 19)}] $text");
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _handleVoxInput() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _voxService.playStaticBurst();
        _speech.listen(onResult: (result) {
          setState(() {
            _inputController.text = result.recognizedWords;
          });
          if (result.finalResult) {
            setState(() => _isListening = false);
            _processCommand(_inputController.text);
            _inputController.clear();
          }
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _processCommand(String cmd) async {
    final lower = cmd.toLowerCase().trim();
    _appendLog("VOX IN: \"$cmd\"");
    _voxService.playChime();

    if (lower.contains("muster") || lower.contains("agenda") || lower.contains("calendar")) {
      _appendLog("QUERYING CHRONO-MUSTERS VIA HOLY RELAY...");
      try {
        final res = await widget.apiClient.getMusters();
        final musters = res['payload']['musters'] as List<dynamic>;
        if (musters.isEmpty) {
          _appendLog("ZERO MUSTERS SCHEDULED FOR ACTIVE CYCLE.");
        } else {
          for (var m in musters) {
            _appendLog("MUSTER: [\${m['start']}-\${m['end']}] \${m['title']}");
          }
        }
      } catch (e) {
        _appendLog("ERROR COMMUNICATING WITH CHRONO-VAULT: \$e");
      }
      return;
    }

    if (lower.startsWith("add task") || lower.startsWith("remind me to")) {
      final taskTitle = cmd.replaceFirst(RegExp(r'(add task|remind me to)', caseSensitive: false), '').trim();
      _appendLog("ENGRAVING TASK: \"$taskTitle\"... ");
      try {
        await widget.apiClient.addDirective(taskTitle);
        _appendLog("DIRECTIVE SUCCESSFULLY ENGRAVED IN TASKS REGISTRY.");
      } catch (e) {
        _appendLog("TRANSMISSION ERROR: \$e");
      }
      return;
    }

    final proteinMatch = RegExp(r'(\d+)\s*(g|grams|protein)').firstMatch(lower);
    final waterMatch = RegExp(r'(\d+(\.\d+)?)\s*(l|liters|water)').firstMatch(lower);
    final kineticMatch = RegExp(r'(\d+)\s*(mins|minutes|kinetic)').firstMatch(lower);

    if (proteinMatch != null || waterMatch != null || kineticMatch != null) {
      if (proteinMatch != null) _protein = double.parse(proteinMatch.group(1)!);
      if (waterMatch != null) _water = double.parse(waterMatch.group(1)!);
      if (kineticMatch != null) _kinetic = int.parse(kineticMatch.group(1)!);

      _appendLog("TRANSMITTING BIOMETRICS TO CORPUS CRUSADE...");
      try {
        final res = await widget.apiClient.logTelemetry(
          weight: 78.5,
          water: _water,
          protein: _protein,
          kineticMinutes: _kinetic,
          stasisHours: 7.5,
          notes: "Vocal telemetry input",
        );
        final xp = res['result']['harvestedXP'];
        setState(() => _xp += (xp as num).toInt());
        _appendLog("TELEMETRY ENGRAVED. +\$xp XP HARVESTED.");
      } catch (e) {
        _appendLog("REPOSIT ERROR: \$e");
      }
      return;
    }

    _appendLog("COMMAND NOT IDENTIFIED BY TECH-SPIRIT.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CogitatorTheme.voidDark,
      body: SafeArea(
        child: CrtScreen(
          child: Column(
            children: [
              CogitatorHudHeader(
                currentXp: _xp,
                cogitatorRank: _rank,
                linkActive: true,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MechanicalDialGauge(
                    label: "HYDRATION",
                    value: _water / 4.0,
                    readout: "\${_water.toStringAsFixed(1)}L",
                  ),
                  MechanicalDialGauge(
                    label: "MASS FUEL",
                    value: _protein / 200.0,
                    readout: "\${_protein.toInt()}g",
                  ),
                  MechanicalDialGauge(
                    label: "KINETIC",
                    value: _kinetic / 90.0,
                    readout: "\${_kinetic}m",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: CogitatorTheme.cogitatorBoxDecoration,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _consoleLogs.length,
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        _consoleLogs[i],
                        style: CogitatorTheme.terminalText,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Color(0xFF040604),
                  border: Border(
                    top: BorderSide(color: CogitatorTheme.terminalBorder, width: 2),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic_off : Icons.mic,
                        color: _isListening ? CogitatorTheme.rustRed : CogitatorTheme.crtGreen,
                      ),
                      onPressed: _handleVoxInput,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        style: CogitatorTheme.terminalText,
                        cursorColor: CogitatorTheme.crtGreen,
                        decoration: InputDecoration(
                          hintText: "Enter sacred liturgy or query...",
                          hintStyle: CogitatorTheme.terminalText.copyWith(color: CogitatorTheme.crtGreenDim),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty) {
                            _processCommand(val);
                            _inputController.clear();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: CogitatorTheme.sanctifiedGold),
                      onPressed: () {
                        if (_inputController.text.trim().isNotEmpty) {
                          _processCommand(_inputController.text);
                          _inputController.clear();
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
