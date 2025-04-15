import 'main.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:fyp_ar/map.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: contactP());
  }
}

class contactP extends StatefulWidget {
  const contactP({super.key});

  @override
  _contactPState createState() => _contactPState();
}

class _contactPState extends State<contactP> {
  int _selectedIndex = 0;

  final List<Map<String, String>> contacts = [
    {
      "name": "Ali Bin Ahmad",
      "phone": "01114236884",
      "email": "adamfaizzz28@gmail.com",
    },
    {
      "name": "Siti Binti Mahmud",
      "phone": "0134567890",
      "email": "siti@uptm.edu.my",
    },
    {"name": "Ahmad Faiz", "phone": "0145678901", "email": "faiz@uptm.edu.my"},
    {
      "name": "Nurul Izzah",
      "phone": "0156789012",
      "email": "nurul@uptm.edu.my",
    },
    {"name": "Zaki Rahman", "phone": "0167890123", "email": "zaki@uptm.edu.my"},
    {
      "name": "Halimah Yacob",
      "phone": "0178901234",
      "email": "halimah@uptm.edu.my",
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainP()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MapPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => contactP()),
        );
        break;
    }
  }

  void _startSearch(BuildContext context) {
    showSearch(context: context, delegate: LocationSearch(contacts));
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _openWhatsApp(String phoneNumber) async {
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _sendEmail(String email) async {
    final Uri url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Widget contactCard(String name, String phone, String email) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green),
                  onPressed: () => _makePhoneCall(phone),
                ),
                IconButton(
                  icon: Icon(Icons.message, color: Colors.teal),
                  onPressed: () => _openWhatsApp(phone),
                ),
                IconButton(
                  icon: Icon(Icons.email, color: Colors.blue),
                  onPressed: () => _sendEmail(email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset("assets/AR.png", height: 40),
      ),
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 180,
                width: double.infinity,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Image.asset('assets/Building.jpg', fit: BoxFit.cover),
                ),
              ),
              Container(
                height: 180,
                width: double.infinity,
                color: Colors.black.withOpacity(0.3),
              ),
              const Text(
                'UPTM Map Navigation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              readOnly: true,
              onTap: () => _startSearch(context),
              decoration: InputDecoration(
                hintText: "Mencari kakitangan kenalan",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...contacts
              .map(
                (contact) => contactCard(
                  contact["name"]!,
                  contact["phone"]!,
                  contact["email"]!,
                ),
              )
              .toList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Laman Utama"),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Destinasi",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.phone), label: "Panggilan"),
        ],
      ),
    );
  }
}

class LocationSearch extends SearchDelegate<String> {
  final List<Map<String, String>> contacts;

  LocationSearch(this.contacts);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, ""),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        contacts
            .where(
              (contact) =>
                  contact["name"]!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    return ListView(
      children:
          results.map((contact) => _contactCard(context, contact)).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        contacts
            .where(
              (contact) =>
                  contact["name"]!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    return ListView(
      children:
          suggestions.map((contact) => _contactCard(context, contact)).toList(),
    );
  }

  Widget _contactCard(BuildContext context, Map<String, String> contact) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact["name"]!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green),
                  onPressed:
                      () => launchUrl(Uri.parse('tel:${contact["phone"]!}')),
                ),
                IconButton(
                  icon: Icon(Icons.message, color: Colors.teal),
                  onPressed:
                      () => launchUrl(
                        Uri.parse('https://wa.me/${contact["phone"]!}'),
                        mode: LaunchMode.externalApplication,
                      ),
                ),
                IconButton(
                  icon: Icon(Icons.email, color: Colors.blue),
                  onPressed:
                      () => launchUrl(Uri.parse('mailto:${contact["email"]!}')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
