import 'package:flutter/material.dart';
import 'package:ocr_app/models/record_element.dart';

class RecordProvider extends ChangeNotifier {
  final List<RecordElement> records = [];

  void addRecord(RecordElement record) {
    records.add(record);
    notifyListeners();
  }

  void updateRecord( Map<String, dynamic> data, String id) {
    int index = records.indexWhere((element) => element.id == id);
    if (index != -1) {
      records[index].data = data;
      notifyListeners();
    }
  }

  void removeRecord(RecordElement record) {
    int index = records.indexOf(record);
    if (index != -1) {
      records.removeAt(index);
      notifyListeners();
    }
  }
}
