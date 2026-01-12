import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // Real API Key provided by user
  static const String _apiKey = 'AIzaSyDcP1Fsa-a1m2D58fGQBpgUgSxJqEffTeM';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  Future<String> sendMessage(String message) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY') {
      return "I need a valid API Key to think! Please update lib/services/gemini_service.dart.";
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{
            "parts": [{"text": "You are a helpful car rental assistant. User asks: $message"}]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Failed to connect to AI: $e";
    }
  }
}
