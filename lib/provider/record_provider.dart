import 'package:flutter/material.dart';
import 'package:ocr_app/models/record_element.dart';

class RecordProvider extends ChangeNotifier {
  final List<RecordElement> records = [];

  void addRecord(RecordElement record) {
    records.add(record);
    notifyListeners();
  }

  void removeRecord(RecordElement record) {
    int index = records.indexOf(record);
    if (index != -1) {
      records.removeAt(index);
      notifyListeners();
    }
  }
}
