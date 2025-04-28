import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VehicleListScreen extends StatelessWidget {
  final String uid;

  const VehicleListScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Миний машинууд"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('vehicles')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Таны бүртгүүлсэн машин алга байна."));
          }

          final vehicles = snapshot.data!.docs;

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(vehicle['plate'] ?? 'Дугаар алга'),
                  subtitle: Text("${vehicle['make']} - ${vehicle['model']} (${vehicle['year']})"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final docId = vehicles[index].id;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('vehicles')
                          .doc(docId)
                          .delete();
                    },
                  ),
                  onTap: () {
                    // Хэрэв та edit дэлгэц рүү оруулах бол энд зааж болно
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
