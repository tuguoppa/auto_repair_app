import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    if (user != null) {
      emailController.text = user!.email ?? '';
      _loadUserProfile();
      _loadUserVehicles();
    }
  }

  Future<void> _loadUserProfile() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final data = doc.data();
    if (data != null) {
      lastNameController.text = data['lastName'] ?? '';
      firstNameController.text = data['firstName'] ?? '';
      phoneController.text = data['phone'] ?? '';
    }
  }

  Future<void> _loadUserVehicles() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('vehicles')
        .get();

    setState(() {
      vehicles = snapshot.docs.map((doc) => {
            'id': doc.id,
            'model': doc['model'],
            'plate': doc['plate'],
          }).toList();
    });
  }

  Future<void> _saveUserProfile() async {
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'lastName': lastNameController.text,
      'firstName': firstNameController.text,
      'phone': phoneController.text,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Хувийн мэдээлэл хадгалагдлаа")),
    );
  }

  Widget _buildVehicleList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return ListTile(
          leading: const Icon(Icons.directions_car),
          title: Text(vehicle['model'] ?? ''),
          subtitle: Text("Дугаар: ${vehicle['plate']}"),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .collection('vehicles')
                  .doc(vehicle['id'])
                  .delete();
              _loadUserVehicles();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Хувийн мэдээлэл"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: "Овог"),
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: "Нэр"),
            ),
            TextField(
              controller: emailController,
              enabled: false,
              decoration: const InputDecoration(labelText: "Имэйл"),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Утас"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveUserProfile,
              child: const Text("Хадгалах"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            const Divider(height: 30),
            const Text("Машины жагсаалт", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildVehicleList(),
          ],
        ),
      ),
    );
  }
}