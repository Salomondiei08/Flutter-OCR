import 'package:flutter/material.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:ocr_app/screens/camera_take_screen.dart';
import 'package:provider/provider.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  @override
  Widget build(BuildContext context) {
    final records = context.watch<RecordProvider>().records;
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR App'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) => ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            selectedTileColor: Colors.orange[100],
            title: Text(
              "Nom :${records[index].name}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                "Date d'entrée : ${records[index].date.toIso8601String()}"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const CameraTakeScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
