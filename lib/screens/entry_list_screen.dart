import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:ocr_app/screens/menu_screen.dart';
import 'package:ocr_app/screens/table_screen.dart';
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
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: SafeArea(
          child: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          TableScreen(data: records[index].data))),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.red[100],
              title: Text(
                "Nom : ${records[index].name}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  "Date d'entrée : ${formatter.format(records[index].date)}"),
              trailing: ElevatedButton(
                child: const Text('Sortir'),
                onPressed: () {
                  context.read<RecordProvider>().removeRecord(records[index]);
                  Fluttertoast.showToast(
                      msg: 'Merci d\'être passé chez nous !');
                },
              ),
            ),
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const MenuScreen(),
          ),
        ),
      ),
    );
  }
}
