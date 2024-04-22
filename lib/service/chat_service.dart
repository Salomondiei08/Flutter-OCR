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

  static Future<Map<String, dynamic>> recognizeText(String imagePath) async {
    // Getting the base64 string
    String base64Image = encodeImage(imagePath);

    // Constructing the data URI
    String dataUri = "data:image/jpeg;base64,$base64Image";

    print(dataUri);

    const url =
        'https://ocrfuturafric.openai.azure.com/openai/deployments/ocr/chat/completions?api-version=2023-12-01-preview';

    final body = {
      "messages": [
        {
          "role": "system",
          "content":
              "Tu es un assitant utilisé pour récupéré les informations contenues sur des document d'authentification. ton role sera de récupérer tous les champs résents sur la cart et leurs valeurs et de ne retourner qu'un json contenant ces éléments"
        },
        {
          "role": "user",
          "content": [
            {
              "type": "image_url",
              "image_url": {"url": dataUri}
            }
          ]
        }
      ],
      "max_tokens": 4096
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
      final result = json.decode(response.body);
      final chatResponse = result['choices'][0]['message']['content'];
      print(removeJsonTags(chatResponse));
      return jsonDecode(removeJsonTags(chatResponse));
    } else {
      throw Exception('Failed to recognize text. ${response.statusCode}');
    }
  }
}
