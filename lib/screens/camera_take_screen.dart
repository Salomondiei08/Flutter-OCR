import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ocr_app/models/record_element.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:ocr_app/service/chat_service.dart';
import 'package:provider/provider.dart';

class CameraTakeScreen extends StatefulWidget {
  const CameraTakeScreen(
      {super.key, required this.name, required this.reeason});
  final String name;
  final String reeason;

  @override
  State<CameraTakeScreen> createState() => _CameraTakeScreenState();
}

class _CameraTakeScreenState extends State<CameraTakeScreen>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _cameraController = CameraController(
        const CameraDescription(
            name: '0',
            lensDirection: CameraLensDirection.front,
            sensorOrientation: 1),
        ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.1, end: 1).animate(_controller);

    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        await takePicture();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (value > 0) {
          value--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _cameraController.dispose();
    _timer.cancel();
    super.dispose();
  }

  late XFile image;

  bool isDoingOperation = false;
  int value = 4;
  late Timer _timer;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox.expand(
        child: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(child: CameraPreview(_cameraController)),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: isDoingOperation ? 1.0 : 0.0,
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Circular Progress Indicator
                  Visibility(
                    visible: isDoingOperation,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Chargement des informations')
                      ],
                    ),
                  ),
                  Center(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          height: size.width * 0.8,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(_animation
                                  .value), // Varying opacity for the glow effect
                              width: _animation.value * 3 + 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    child: Text(
                      value.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Veuillez placer la carte Ici',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
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
      image = await _cameraController.takePicture();

      setState(() {
        isDoingOperation = true;
      });

      var text = await extractText(File(image.path));

      if (text.isEmpty) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Text Ttop Flou ou non détecté !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xffe2001a),
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      final data = await AzureOCR.recognizeText(text);

      // Add the record to the provider.
      context.read<RecordProvider>().addRecord(
            RecordElement(
              vistedPerson: widget.name,
              id: DateTime.now().toString(),
              resaon: widget.reeason,
              name: data['Nom'] ?? '',
              imagePath: image.path,
              date: DateTime.now(),
              data: data,
            ),
          );

      Fluttertoast.showToast(
          msg: "Enregistrement ajouté",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      // If the picture was taken, display it on a new screen.
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffe2001a),
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        isDoingOperation = false;
      });
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
}
