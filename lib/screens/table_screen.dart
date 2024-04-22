import 'package:flutter/material.dart';

class TableScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const TableScreen({super.key, required this.data});

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
            children: data.entries.map((entry) {
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
                      child: Text(entry.value.toString()),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
