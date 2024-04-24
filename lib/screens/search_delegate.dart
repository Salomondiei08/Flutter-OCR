import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ocr_app/provider/record_provider.dart';
import 'package:ocr_app/screens/table_screen.dart';
import 'package:provider/provider.dart';

class ListSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    final recordList = context.read<RecordProvider>().records;
    final records = recordList
        .where(
            (record) => record.name.toUpperCase().contains(query.toUpperCase()))
        .toList();
    final DateFormat formatter = DateFormat('MMMM d - hh:mm');

    return (records.isEmpty)
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
                          data: records[index].data, id: records[index].id),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: const Color(0xffe2001a).withOpacity(0.1),
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
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final recordList = context.read<RecordProvider>().records;
    final records = recordList
        .where(
            (record) => record.name.toUpperCase().contains(query.toUpperCase()))
        .toList();
    final DateFormat formatter = DateFormat('MMMM d - hh:mm');

    return (records.isEmpty)
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
                const SizedBox(height: 30),
                const Text(
                  'Aucun enregistrement trouvé',
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
                              id: records[index].id))),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: const Color(0xffe2001a).withOpacity(0.1),
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
          );
  }
}
