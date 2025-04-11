// lib/screens/spare_parts_screen.dart
import 'package:flutter/material.dart';

class SparePartsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> parts = [
    {"name": "Тормозны наклад", "quantity": 12, "price": 35000},
    {"name": "Масло шүүгч", "quantity": 24, "price": 15000},
    {"name": "Сэлбэгийн оосор", "quantity": 10, "price": 8000},
    {"name": "Хөдөлгүүрийн ремень", "quantity": 5, "price": 40000},
    {"name": "Агаар шүүгч", "quantity": 18, "price": 12000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Сэлбэгийн жагсаалт"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: parts.length,
        itemBuilder: (context, index) {
          final item = parts[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text(item['name']),
              subtitle: Text("Тоо: ${item['quantity']}  |  Үнэ: ${item['price']}₮"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Show part details or edit
              },
            ),
          );
        },
      ),
    );
  }
}
