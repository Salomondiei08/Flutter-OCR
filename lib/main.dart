import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:ocr_app/screens/entry_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('OCR');
  RecordProvider().getFromStorage();
  initializeDateFormatting('fr');

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
          colorScheme: const ColorScheme.light(primary: Color(0xffe2001a)),
        ),
        debugShowCheckedModeBanner: false,
        title: 'CORIS Bank',
        home: const EntryListScreen(),
      ),
    );
  }
}
