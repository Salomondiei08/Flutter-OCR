import 'package:flutter/material.dart';
import 'package:ocr_app/screens/camera_take_screen.dart';
import 'package:ocr_app/screens/contact_list.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const  Color(0xffe2001a),
        title: const Text(
          'Bienvenue à CORIS Bank',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, childAspectRatio: 1),
            children: const [
              MenuWidget(
                text: 'J\'ai un Rendez-vous',
                imageUrl: 'assets/images/rdv.png',
              ),
              MenuWidget(
                text: 'Je rends visite',
                imageUrl: 'assets/images/check.png',
              ),
              MenuWidget(
                isListNeeded: true,
                text: 'Je suis employé',
                imageUrl: 'assets/images/recruitment.png',
              ),
              MenuWidget(
                isListNeeded: true,
                text: 'Je suis prestataire',
                imageUrl: 'assets/images/workers.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    required this.imageUrl,
    required this.text,
    this.isListNeeded = false,
  });

  final String imageUrl;
  final String text;
  final bool isListNeeded;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => isListNeeded
              ? const CameraTakeScreen(
                  name: '',
                  reeason: '',
                )
              : ContactListScreen(
                  text: text,
                ),
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(imageUrl),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
