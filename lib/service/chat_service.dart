import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

String removeJsonTags(String text) {
  if (text.startsWith("```json") && text.endsWith("```")) {
    return text.substring(
        7,
        text.length -
            3); // Removing '```json' at the beginning and '```' at the end
  } else {
    return text;
  }
}

// Function to encode the image
String encodeImage(String imagePath) {
  // Read the image file as bytes
  List<int> imageBytes = File(imagePath).readAsBytesSync();

  // Encode the bytes as base64 string
  String base64Image = base64Encode(imageBytes);

  return base64Image;
}

class AzureOCR {
  AzureOCR();

  static Future<Map<String, dynamic>> recognizeText(String text) async {
    // Getting the base64 string
    print(text);
    const url =
        'https://ocrfuturafric.openai.azure.com/openai/deployments/ciprel/chat/completions?api-version=2024-02-15-preview';

    final body = {
      "messages": [
        {
          "role": "system",
          "content":
              "Tu es un assitant utilisé pour bien agencé les information recuiellies sur une piece d'identite, ta mission est de retourner à chque fois un json contentant chaque champs et sa valeur français, Temperature=0, n'allucine pas, ta reponse doit toujours être un json"
        },
        {"role": "user", "content": text}
      ],
      "temperature": 0,
      "model": "gpt-3.5-turbo"
    };

    final headers = {
      'Content-Type': 'application/json',
      'api-key': 'accbad07ba1e4aff87d041289c15b24f',
    };

    final requestBody = jsonEncode(body);
    final response = await post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final result = json.decode(utf8.decode((response.bodyBytes)));
      final chatResponse = result['choices'][0]['message']['content'];
      print(removeJsonTags(chatResponse));
      return jsonDecode(removeJsonTags(chatResponse));
    } else {
      throw Exception('${response.reasonPhrase} ${response.statusCode}');
    }
  }
}
