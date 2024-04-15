import 'package:flutter/material.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:ocr_app/screens/ocr_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const OCRApp());
}

class OCRApp extends StatelessWidget {
  const OCRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecordProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OCR App',
        home: OCRScreen(),
      ),
    );
  }
}
