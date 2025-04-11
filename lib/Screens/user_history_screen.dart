// lib/screens/user_history_screen.dart
import 'package:flutter/material.dart';

class UserHistoryScreen extends StatelessWidget {
  final String userName;
  final List<Map<String, String>> history;

  const UserHistoryScreen({required this.userName, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$userName - Үйлчилгээний түүх"),
        backgroundColor: Colors.blue,
      ),
      body: history.isEmpty
          ? Center(child: Text("Одоогоор үйлчилгээ бүртгэгдээгүй байна."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.build_circle_outlined),
                    title: Text(item['service'] ?? ''),
                    subtitle: Text(
                      "Гэмтэл: ${item['issue']}\nСэлбэг: ${item['parts']}\nОгноо: ${item['date']}"
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
