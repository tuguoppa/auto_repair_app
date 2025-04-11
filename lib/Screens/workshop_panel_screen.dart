// lib/screens/workshop_panel_screen.dart
import 'package:flutter/material.dart';

class WorkshopPanelScreen extends StatelessWidget {
  final String name;
  const WorkshopPanelScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workshop Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Сайн байна уу, $name!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Show today's service orders
              },
              icon: Icon(Icons.build),
              label: Text("Засварын захиалгууд"),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Show spare parts inventory
              },
              icon: Icon(Icons.settings),
              label: Text("Сэлбэгийн мэдээлэл"),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Show my profile
              },
              icon: Icon(Icons.person),
              label: Text("Профайл харах"),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout),
              label: Text("Гарах"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
