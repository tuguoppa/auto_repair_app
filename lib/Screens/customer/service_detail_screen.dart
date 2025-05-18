import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final name = service['name'] ?? 'Нэр байхгүй';
    final description = service['description'] ?? 'Тайлбар алга';
    final price = service['price'] ?? 0;
    final carType = service['carType'] ?? 'Машины төрөл байхгүй';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),
                Text("Тайлбар:",
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 6),
                Text(description),
                const SizedBox(height: 16),
                Text("Үнэ: $price₮", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("Машины төрөл: $carType", style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
