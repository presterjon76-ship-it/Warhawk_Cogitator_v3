import 'package:flutter/material.dart';
import 'screens/cogitator_terminal.dart';
import 'services/cogitator_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // PASTE YOUR GOOGLE APPS SCRIPT WEB APP URL (ending in /exec) HERE
  const String deployedAppsScriptUrl = "https://script.google.com/macros/s/AKfycbyeX_w1D_RTZQ_A99Yw4yHIcahuN6fqLGXxIInaavHJXt_Pra4SzaQ6Mx3G-oQigwEb/exec";

  final apiClient = CogitatorApiClient(webhookEndpoint: deployedAppsScriptUrl);

  runApp(WarhawkCogitatorApp(apiClient: apiClient));
}

class WarhawkCogitatorApp extends StatelessWidget {
  final CogitatorApiClient apiClient;

  const WarhawkCogitatorApp({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adeptus Mechanicus Field Cogitator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: CogitatorTerminalScreen(apiClient: apiClient),
    );
  }
}
