import 'package:flutter/material.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController numberController = TextEditingController();
  String region1 = 'У';
  String region2 = 'Б';
  String region3 = 'А';

  void _searchVehicle() {
    final number = numberController.text;
    final plate = '$number $region1$region2$region3';

    // TODO: Backend-ээс мэдээлэл татах

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Машины мэдээлэл олдлоо'),
        content: Text('Дугаар: $plate\nМарк: Toyota\nҮйлдвэрлэсэн он: 2015'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Машин нэмэх'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Та улсын дугаараар хайж машин нэмнэ үү"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Дугаар'),
                  ),
                ),
                const SizedBox(width: 8),
                _charBox(region1, (val) => setState(() => region1 = val)),
                _charBox(region2, (val) => setState(() => region2 = val)),
                _charBox(region3, (val) => setState(() => region3 = val)),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _searchVehicle,
              child: const Text('Хайх'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            )
          ],
        ),
      ),
    );
  }

  Widget _charBox(String value, Function(String) onChanged) {
    return SizedBox(
      width: 40,
      child: TextFormField(
        initialValue: value,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(counterText: ''),
        onChanged: onChanged,
      ),
    );
  }
}
