import 'package:flutter/material.dart';
import 'add_vehicle_screen.dart';

class VehicleListScreen extends StatelessWidget {
  final List<Map<String, String>> vehicles;

  const VehicleListScreen({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Миний машинууд'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return Card(
            child: ListTile(
              leading: Image.asset(vehicle['brandLogo'] ?? '', width: 40),
              title: Text('${vehicle['plate']}'),
              subtitle: Text(vehicle['brand'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Машин устгах логик
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${vehicle['plate']} устгагдлаа')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
