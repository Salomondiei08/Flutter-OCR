import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ocr_app/screens/camera_take_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key, required this.text});
  final String text;

  @override
  State<ContactListScreen> createState() => ContactListScreenState();
}

class ContactListScreenState extends State<ContactListScreen> {
  List<String> contactList = ['Habibou Metais'];

  List<String> searchedList = [];

  @override
  void initState() {
    searchedList = contactList;
    _searchController.addListener(() {
      setState(() {
        searchedList = contactList
            .where((element) => element
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  final _nameController = TextEditingController();

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffe2001a),
        title: const Text(
          'Personnes à visiter',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Qui voulez vous visiter ?'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) =>
                      StatefulBuilder(builder: (context, setState) {
                    return SimpleDialog(
                      surfaceTintColor: Colors.white,
                      title: const Text(
                        'Veuillez saisir le nom de la personne',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => CameraTakeScreen(
                                    name: _nameController.text.trim(),
                                    reeason: widget.text,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text(
                                'Confirmer',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  }),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Ajouter un nom',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.8,
              child: ListView.builder(
                itemCount: searchedList.length,
                itemBuilder: (context, index) => InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: ListTile(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          surfaceTintColor: Colors.white,
                          title: const Text(
                            'Heure du rendez-vous',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: [
                            HourWidget(
                              time: '10h',
                              name: widget.text,
                              reason: contactList[index],
                            ),
                            HourWidget(
                              time: '11h',
                              name: widget.text,
                              reason: contactList[index],
                            ),
                            HourWidget(
                              time: '12h',
                              name: widget.text,
                              reason: contactList[index],
                            ),
                            HourWidget(
                              time: '13h',
                              name: widget.text,
                              reason: contactList[index],
                            ),
                            HourWidget(
                              time: '14h',
                              name: widget.text,
                              reason: contactList[index],
                            ),
                            HourWidget(
                              time: '15h',
                              name: widget.text,
                              reason: contactList[index],
                            ),
                            HourWidget(
                              time: '16h',
                              name: widget.text,
                              reason: contactList[index],
                            ),
                            HourWidget(
                              time: '17h',
                              name: widget.text,
                              reason: contactList[index],
                            ),
                            HourWidget(
                              time: '18h',
                              name: widget.text,
                              reason: contactList[index],
                            ),
                          ],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: const Color(0xffe2001a).withOpacity(0.2),
                      title: Text(contactList[index]),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HourWidget extends StatelessWidget {
  const HourWidget({
    super.key,
    required this.time,
    required this.name,
    required this.reason,
  });
  final String time;
  final String name;
  final String reason;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => CameraTakeScreen(
            name: name,
            reeason: reason,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          time,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
