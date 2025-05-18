import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_repair_screen.dart';

enum SearchType { plate, name, phone }

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchType _selectedType = SearchType.plate;

  Map<String, dynamic>? userData;
  String? userId;

  Future<void> _searchUser() async {
    final input = _searchController.text.trim().toLowerCase();
    if (input.isEmpty) return;

    final userSnapshot = await FirebaseFirestore.instance.collection('users').get();

    for (var userDoc in userSnapshot.docs) {
      final user = userDoc.data();
      final uid = userDoc.id;

      // Нэрээр хайх
      if (_selectedType == SearchType.name) {
        final fullName = "${user['firstName'] ?? ''} ${user['lastName'] ?? ''}".toLowerCase();
        if (fullName.contains(input)) {
          await _selectVehicleAndProceed(uid, userDoc);
          return;
        }
      }

      // Утасны дугаараар хайх
      if (_selectedType == SearchType.phone) {
        if ((user['phone'] ?? '').toString().toLowerCase().contains(input)) {
          await _selectVehicleAndProceed(uid, userDoc);
          return;
        }
      }

      // Улсын дугаараар хайх
      if (_selectedType == SearchType.plate) {
        final vehiclesSnapshot = await userDoc.reference.collection('vehicles').get();
        final matchedCars = <Map<String, dynamic>>[];

        for (var vehicleDoc in vehiclesSnapshot.docs) {
          final plate = (vehicleDoc['plate'] ?? '').toString().toLowerCase().replaceAll(' ', '');
          if (plate.contains(input.replaceAll(' ', ''))) {
            matchedCars.add(vehicleDoc.data());
          }
        }

        if (matchedCars.isNotEmpty) {
          await _showVehicleChoice(uid, userDoc.data(), matchedCars);
          return;
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Хэрэглэгч олдсонгүй.")),
    );
  }

  Future<void> _selectVehicleAndProceed(String uid, DocumentSnapshot userDoc) async {
    final vehicleSnapshot = await userDoc.reference.collection('vehicles').get();
    final vehicleList = vehicleSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    await _showVehicleChoice(uid, userDoc.data() as Map<String, dynamic>, vehicleList);
  }

  Future<void> _showVehicleChoice(String uid, Map<String, dynamic> user, List<Map<String, dynamic>> vehicles) async {
    final selected = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final car = vehicles[index];
            return ListTile(
              leading: const Icon(Icons.directions_car),
              title: Text("${car['plate']} - ${car['model']}"),
              subtitle: Text("Өнгө: ${car['color'] ?? '-'}, Он: ${car['year'] ?? '-'}"),
              onTap: () => Navigator.pop(context, car),
            );
          },
        );
      },
    );

    if (selected != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreateRepairScreen(
            user: {
              'id': uid,
              'firstName': user['firstName'] ?? '',
              'lastName': user['lastName'] ?? '',
              'phone': user['phone'] ?? '',
              'car': selected['plate'],
              'model': selected['model'],
              'color': selected['color'],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<SearchType>(
              value: _selectedType,
              onChanged: (val) => setState(() => _selectedType = val!),
              items: const [
                DropdownMenuItem(value: SearchType.plate, child: Text("Улсын дугаар")),
                DropdownMenuItem(value: SearchType.name, child: Text("Нэр")),
                DropdownMenuItem(value: SearchType.phone, child: Text("Утас")),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Хайх утга", border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _searchUser,
              child: const Text("Хайх"),
            )
          ],
        ),
      ),
    );
  }
}
