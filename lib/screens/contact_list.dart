import 'package:flutter/material.dart';
import 'package:ocr_app/screens/camera_take_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key, required this.text});
  final String text;

  @override
  State<ContactListScreen> createState() => ContactListScreenState();
}

class ContactListScreenState extends State<ContactListScreen> {
  List<String> contactList = [
    'Jean Pascal',
    'Patrick Jean',
    'Yves Bragbo',
    'Jean Pascal',
    'Patrick Jean',
    'Jean Pascal',
    'Patrick Jean',
    'Jean Pascal',
    'Patrick Jean',
  ];

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

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Personnes à visiter',
            style: TextStyle(color: Color(0xffe2001a)),
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
              SizedBox(
                height: size.height * 0.8,
                child: ListView.builder(
                    itemCount: searchedList.length,
                    itemBuilder: (context, index) => InkWell(
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
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: size.height * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffe2001a).withOpacity(0.1)),
                            child: Text(
                              searchedList[index],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
              )
            ],
          ),
        ));
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
                  ))),
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
