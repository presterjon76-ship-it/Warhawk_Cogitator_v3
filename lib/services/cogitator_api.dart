import 'dart:convert';
import 'dart:io';

class CogitatorApiClient {
  final String webhookEndpoint;

  CogitatorApiClient({required this.webhookEndpoint});

  Future<Map<String, dynamic>> _executeWithRedirectResolution({
    required String method,
    required Uri uri,
    Map<String, dynamic>? jsonPayload,
  }) async {
    final client = HttpClient();
    try {
      Uri currentUri = uri;
      int redirectLimit = 5;

      while (redirectLimit > 0) {
        HttpClientRequest request;
        if (method == "POST") {
          request = await client.postUrl(currentUri);
          request.headers.contentType = ContentType.json;
          if (jsonPayload != null) {
            request.write(jsonEncode(jsonPayload));
          }
        } else {
          request = await client.getUrl(currentUri);
        }

        request.followRedirects = false;
        final response = await request.close();

        if (response.isRedirect) {
          final location = response.headers.value(HttpHeaders.locationHeader);
          if (location != null) {
            currentUri = Uri.parse(location);
            redirectLimit--;
            method = "GET";
            continue;
          }
        }

        final responseBody = await response.transform(utf8.decoder).join();
        return jsonDecode(responseBody) as Map<String, dynamic>;
      }
      throw HttpException("Redirect loop exceeded limits.");
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> logTelemetry({
    required double weight,
    required double water,
    required double protein,
    required int kineticMinutes,
    required double stasisHours,
    required String notes,
  }) async {
    final payload = {
      "intent": "LOG_TELEMETRY",
      "weight": weight,
      "water": water,
      "protein": protein,
      "kinetic": kineticMinutes,
      "stasis": stasisHours,
      "liturgies": notes,
    };

    return await _executeWithRedirectResolution(
      method: "POST",
      uri: Uri.parse(webhookEndpoint),
      jsonPayload: payload,
    );
  }

  Future<Map<String, dynamic>> addDirective(String title, {String? notes}) async {
    final payload = {
      "intent": "ADD_TASK",
      "title": title,
      "notes": notes ?? "Recorded via vox prompt",
    };

    return await _executeWithRedirectResolution(
      method: "POST",
      uri: Uri.parse(webhookEndpoint),
      jsonPayload: payload,
    );
  }

  Future<Map<String, dynamic>> getMusters() async {
    final uri = Uri.parse(webhookEndpoint).replace(queryParameters: {"action": "musters"});
    return await _executeWithRedirectResolution(method: "GET", uri: uri);
  }

  Future<Map<String, dynamic>> getDirectives() async {
    final uri = Uri.parse(webhookEndpoint).replace(queryParameters: {"action": "directives"});
    return await _executeWithRedirectResolution(method: "GET", uri: uri);
  }
}
