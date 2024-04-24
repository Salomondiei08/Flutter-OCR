import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ocr_app/models/record_element.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:ocr_app/screens/menu_screen.dart';
import 'package:ocr_app/screens/search_delegate.dart';
import 'package:ocr_app/screens/table_screen.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class EntryListScreen extends StatefulWidget {
  const EntryListScreen({super.key});

  @override
  State<EntryListScreen> createState() => _EntryListScreenState();
}

class _EntryListScreenState extends State<EntryListScreen> {
  final DateFormat formatter = DateFormat('MMMM d - hh:mm');

  @override
  Widget build(BuildContext context) {
    final records = context.watch<RecordProvider>().records;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personnes enrégistrées',
          style: TextStyle(color: Color(0xffe2001a)),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: ListSearchDelegate(),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: (records.isEmpty)
              ? SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/empty.png'),
                          ),
                        ),
                      ),
                      const Text(
                        'Aucun enregistrement',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => TableScreen(
                                data: records[index].data,
                                id: records[index].id),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        tileColor: const Color(0xffe2001a).withOpacity(0.2),
                        title: Text(
                          "Nom : ${records[index].name}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "Date d'entrée : ${formatter.format(records[index].date)}"),
                        trailing: ElevatedButton(
                          child: const Text('Sortir'),
                          onPressed: () {
                            context
                                .read<RecordProvider>()
                                .removeRecord(records[index]);
                            Fluttertoast.showToast(
                                msg: 'Merci d\'être passé chez nous !');
                          },
                        ),
                      ),
                    ),
                  ),
                )),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.share),
            onPressed: () async => await exportExcelFile(records: records),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const MenuScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> exportExcelFile({required List<RecordElement> records}) async {
    var excel = Excel.createExcel();

    var sheetObject = excel['aujourdhui'];

    for (var record in records) {
      List<CellValue> dataList = [];

      dataList.add(TextCellValue(record.name));
      dataList.add(TextCellValue(record.resaon));
      dataList.add(TextCellValue(record.date.toString()));

      record.data.forEach((key, value) {
        dataList.add(TextCellValue(value));
      });

      sheetObject.insertRowIterables(dataList, sheetObject.maxRows);
    }

    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();

    final File file = File('${directory.path}/record.xlsx')
      ..createSync(recursive: true);
    file.writeAsBytesSync(fileBytes!);

    OpenFile.open("${directory.path}/record.xlsx");
  }
}
