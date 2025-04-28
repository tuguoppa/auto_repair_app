import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_repair_screen.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _plateController = TextEditingController();
  Map<String, dynamic>? userData;
  String? userId;
  String? userCar;

  Future<void> _searchUserByPlate() async {
    final plateInput = _plateController.text.trim().toLowerCase();
    if (plateInput.isEmpty) return;

    final userSnapshot = await FirebaseFirestore.instance.collection('users').get();
    for (var userDoc in userSnapshot.docs) {
      final vehiclesSnapshot = await userDoc.reference.collection('vehicles').get();
      for (var vehicleDoc in vehiclesSnapshot.docs) {
        final plate = (vehicleDoc['plate'] ?? '').toString().toLowerCase();
        if (plate.contains(plateInput)) {
          setState(() {
            userData = userDoc.data();
            userId = userDoc.id;
            userCar = vehicleDoc['plate'];
          });
          return;
        }
      }
    }

    setState(() {
      userData = null;
      userId = null;
      userCar = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Хэрэглэгч олдсонгүй.")),
    );
  }

  void _proceedToService() {
    if (userId != null && userData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreateRepairScreen(
            user: {
              'id': userId,
              'firstName': userData!['firstName'] ?? '',
              'lastName': userData!['lastName'] ?? '',
              'phone': userData!['phone'] ?? '',
              'car': userCar ?? '',
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Хэрэглэгч хайх"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _plateController,
              decoration: const InputDecoration(
                labelText: "Улсын дугаар",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchUserByPlate,
              child: const Text("Хайх"),
            ),
            const SizedBox(height: 24),
            if (userData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Нэр: ${userData!['firstName'] ?? ''} ${userData!['lastName'] ?? ''}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text("Утас: ${userData!['phone'] ?? ''}", style: const TextStyle(fontSize: 16)),
                  Text("Машин: ${userCar ?? ''}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _proceedToService,
                    child: const Text("Үйлчилгээ үзүүлэх"),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
