import 'package:flutter/material.dart';
import 'package:fyp_ar/contact.dart';
import 'main.dart';
import 'dart:ui';

void main() => runApp(const MapPage());

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: MapP());
  }
}

class MapP extends StatefulWidget {
  const MapP({super.key});

  @override
  _MapPState createState() => _MapPState();
}

class _MapPState extends State<MapP> {
  int _selectedIndex = 1;
  String selectedLocation = "";

  final Map<String, Offset> locations = {
    "Bilik Pensyarah A": Offset(280.4, 220.6),
    "Bilik Pensyarah B": Offset(280.1, 304.0),
    "Bilik Pensyarah C": Offset(120.1, 350.5),
    "Bilik Pensyarah D": Offset(104.8, 66.7),
    "Lift 1": Offset(239.7, 114.7), // titik permulaan
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainP()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const contactP()),
        );
        break;
    }
  }

  void _startSearch(BuildContext context) async {
    final result = await showSearch<String>(
      context: context,
      delegate: LocationSearch(
        locations.keys.where((key) => key != "Lift 1").toList(),
      ),
    );

    if (result != null && locations.containsKey(result)) {
      setState(() {
        selectedLocation = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                readOnly: true,
                onTap: () => _startSearch(context),
                decoration: InputDecoration(
                  hintText: "Mencari Lokasi",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(80),
                minScale: 0.5,
                maxScale: 4,
                child: Stack(
                  children: [
                    // Gambar dalam GestureDetector utk log koordinat
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        print("Koordinat: ${details.localPosition}");
                      },
                      child: Image.asset("assets/3rd_floor.png"),
                    ),
                    if (selectedLocation.isNotEmpty) ...[
                      CustomPaint(
                        painter: PathPainter(
                          start: locations["Lift 1"]!,
                          end: locations[selectedLocation]!,
                        ),
                      ),
                      Positioned(
                        left: locations[selectedLocation]!.dx - 12,
                        top: locations[selectedLocation]!.dy - 12,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      Positioned(
                        left: locations["Lift 1"]!.dx - 12,
                        top: locations["Lift 1"]!.dy - 12,
                        child: const Icon(
                          Icons.flag,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
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
  final List<String> locations;

  LocationSearch(this.locations);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text("Navigating to: $query"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        locations
            .where((loc) => loc.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(suggestions[index]),
          onTap: () {
            close(context, suggestions[index]);
          },
        );
      },
    );
  }
}

class PathPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  PathPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(start.dx, start.dy);

    // Simple direction path (with basic turn)
    double midX = (start.dx + end.dx) / 2;
    path.lineTo(midX, start.dy);
    path.lineTo(midX, end.dy);
    path.lineTo(end.dx, end.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
