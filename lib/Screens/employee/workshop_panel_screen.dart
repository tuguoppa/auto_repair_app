import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login_select_screen.dart';
import 'search_user_screen.dart';
import 'service_action_screen.dart';

class WorkshopPanelScreen extends StatelessWidget {
  final String name;
  const WorkshopPanelScreen({super.key, required this.name});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginSelectScreen()),
      (route) => false,
    );
  }

  void _showSpareParts(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final partsSnapshot = await FirebaseFirestore.instance
        .collection('workshops')
        .doc(uid)
        .collection('spare_parts')
        .get();

    final parts = partsSnapshot.docs
        .map((doc) => doc.data())
        .toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Сэлбэгийн жагсаалт"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            children: parts.map((part) {
              return ListTile(
                title: Text(part['name'] ?? 'Нэр алга'),
                subtitle: Text("Тоо: \${part['quantity'] ?? '0'}"),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Хаах"),
          )
        ],
      ),
    );
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchUserScreen()),
    );
  }

  void _navigateToServiceAction(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ServiceActionScreen(userId: uid)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workshop Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Сайн байна уу, \$name!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _navigateToSearch(context),
              icon: const Icon(Icons.search),
              label: const Text("Хэрэглэгч хайх"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _navigateToServiceAction(context),
              icon: const Icon(Icons.build),
              label: const Text("Үйлчилгээ үзүүлэх"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _showSpareParts(context),
              icon: const Icon(Icons.settings),
              label: const Text("Сэлбэгийн мэдээлэл"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Show profile or settings
              },
              icon: const Icon(Icons.person),
              label: const Text("Профайл харах"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Гарах"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
