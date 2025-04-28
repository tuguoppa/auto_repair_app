import 'package:flutter/material.dart';
import 'customer/login_screen.dart';
import 'employee/workshop_login_screen.dart';

class LoginSelectScreen extends StatelessWidget {
  const LoginSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 24, 24),
      appBar: AppBar(
        title: const Text('Нэвтрэх төрөл сонгох'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              icon: const Icon(Icons.person),
              label: const Text('Хэрэглэгчээр нэвтрэх'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 2, 2, 2),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkshopLoginScreen()),
                );
              },
              icon: const Icon(Icons.engineering),
              label: const Text('Ажилтнаар нэвтрэх'),
            ),
          ],
        ),
      ),
    );
  }
}
