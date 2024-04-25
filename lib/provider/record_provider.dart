import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ocr_app/models/record_element.dart';

Box recordBox = Hive.box('OCR');

class RecordProvider extends ChangeNotifier {
  List<RecordElement> records = [];

  void addToLocalStorage(jsonData) {
    recordBox.put('records', jsonData);
  }

  void getFromStorage() {
    final content = recordBox.get('records');

    if (content != null) {
      final decodedData = content;
      final data = decodedData['data'];


    }
  }

  void addRecord(RecordElement record) {
    addToLocalStorage(record.toJson());
    records.add(record);
    notifyListeners();
  }

  void updateRecord(Map<String, dynamic> data, String id) {
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
