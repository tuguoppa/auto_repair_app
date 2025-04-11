// lib/screens/user_list_screen.dart
import 'package:flutter/material.dart';
import 'create_repair_screen.dart';

class UserListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {"name": "Бат", "phone": "99112233", "car": "Toyota Prius 30"},
    {"name": "Саруул", "phone": "88113344", "car": "Nissan X-Trail"},
    {"name": "Мөнхжин", "phone": "90114455", "car": "Mark X"},
    {"name": "Эрдэнэ", "phone": "96115566", "car": "Hyundai Sonata"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Бүртгэлтэй хэрэглэгчид"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(user['name']),
              subtitle: Text("Утас: ${user['phone']}\nМашин: ${user['car']}"),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateRepairScreen(user: user),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
