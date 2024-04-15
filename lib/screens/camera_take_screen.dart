import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ocr_app/models/record_element.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:provider/provider.dart';

class CameraTakeScreen extends StatefulWidget {
  const CameraTakeScreen({super.key});

  @override
  State<CameraTakeScreen> createState() => _CameraTakeScreenState();
}

class _CameraTakeScreenState extends State<CameraTakeScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // Get a specific camera from the list of available cameras.
    _cameraController = CameraController(
        const CameraDescription(
            name: '0',
            lensDirection: CameraLensDirection.back,
            sensorOrientation: 1),
        ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  CameraPreview(_cameraController),
                  ElevatedButton(
                    onPressed: () async => await takePicture(),
                    child: const Text('Take Picture'),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    try {
      final image = await _cameraController.takePicture();

      var text = await extractText(File(image.path));
      text = cropText(text);

      // Add the record to the provider.
      context.read<RecordProvider>().addRecord(
            RecordElement(
              name: text,
              imagePath: image.path,
              date: DateTime.now(),
            ),
          );

      Fluttertoast.showToast(
          msg: "Enrégistrement ajouté",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      // If the picture was taken, display it on a new screen.
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Un erreue s'est produite",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<String> extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFile(file));

    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }

  String cropText(String text) {
    int startIndex = text.indexOf('nom(s)');
    int endIndex = text.indexOf('Nom');

    if (startIndex == -1 || endIndex == -1) {
      return text;
    }

    return text.substring(startIndex + 6, endIndex).trim();
  }
}
