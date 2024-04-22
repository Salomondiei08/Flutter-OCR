import 'package:flutter/material.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:ocr_app/screens/entry_list_screen.dart';
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
      child: MaterialApp(
        theme: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.orange),
        ),
        debugShowCheckedModeBanner: false,
        title: 'CORIS Bank',
        home: const EntryListScreen(),
      ),
    );
  }
}
