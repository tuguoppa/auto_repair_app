// lib/screens/workshop_login_screen.dart
import 'package:flutter/material.dart';
import 'workshop_panel_screen.dart';

class WorkshopLoginScreen extends StatefulWidget {
  @override
  _WorkshopLoginScreenState createState() => _WorkshopLoginScreenState();
}

class _WorkshopLoginScreenState extends State<WorkshopLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email == 'staff@repair.com' && password == '654321') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ажилтны нэвтрэлт амжилттай!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WorkshopPanelScreen(name: "Workshop Staff")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Нэвтрэх мэдээлэл буруу байна')), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Засварын ажилтан нэвтрэх"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Workshop Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Имэйл"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Нууц үг"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Нэвтрэх"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
