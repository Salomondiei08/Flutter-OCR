import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:provider/provider.dart';

class TableScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;

  const TableScreen({super.key, required this.data, required this.id});

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    // Initialize TextEditingController for each entry in the data map
    controllers = widget.data.map((key, value) {
      return MapEntry(key, TextEditingController(text: value.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(),
            children: widget.data.entries.map((entry) {
              return TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: controllers[entry.key],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save the edited values
          final Map<String, dynamic> updatedData =
              controllers.map((key, controller) {
            return MapEntry(key, controller.text);
          });

          context.read<RecordProvider>().updateRecord(updatedData, widget.id);
          // Perform operations with updatedData as needed
          print(updatedData);
          Fluttertoast.showToast(
              msg: 'Modification effectuée avec succès',
              backgroundColor: Colors.green);
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose TextEditingController to avoid memory leaks
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }
}
