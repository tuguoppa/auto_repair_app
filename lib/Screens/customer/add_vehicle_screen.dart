import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../car_data.dart';

class AddVehicleScreen extends StatefulWidget {
  final DocumentSnapshot? existingVehicle;
  const AddVehicleScreen({super.key, this.existingVehicle});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  String? selectedColor;

  String selectedChar1 = 'А';
  String selectedChar2 = 'Б';
  String selectedChar3 = 'В';

  late String selectedMake;
  late String selectedModel;
  late String selectedType;

  final List<String> keyboardChars = [
    'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ж', 'З',
    'И', 'Й', 'К', 'Л', 'М', 'Н', 'О', 'Ө',
    'П', 'Р', 'С', 'Т', 'У', 'Ү', 'Ф', 'Х',
    'Ц', 'Ч', 'Ш', 'Э', 'Ю', 'Я'
  ];

  final List<String> mongolianColors = [
    'Цагаан', 'Хар', 'Хүрэн', 'Улаан', 'Хөх', 'Ногоон', 'Шар', 'Саарал', 'Мөнгөлөг', 'Цэнхэр'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingVehicle != null) {
      final data = widget.existingVehicle!.data() as Map<String, dynamic>;
      final plateParts = data['plate'].split(' ');
      numberController.text = plateParts[0];
      selectedChar1 = plateParts[1][0];
      selectedChar2 = plateParts[1][1];
      selectedChar3 = plateParts[1][2];
      selectedMake = data['make'];
      selectedModel = data['model'];
      selectedType = data['type'];
      yearController.text = data['year'];
      selectedColor = data['color'];
    } else {
      selectedMake = carManufacturers.keys.first;
      selectedModel = carManufacturers[selectedMake]!.keys.first;
      selectedType = carManufacturers[selectedMake]![selectedModel]!;
      selectedColor = mongolianColors.first;
    }
  }

  void _showKeyboardPicker(Function(String) onSelect) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Үсэг сонгох'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: keyboardChars.map((char) {
            return ElevatedButton(
              onPressed: () {
                onSelect(char);
                Navigator.pop(context);
              },
              child: Text(char),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _saveVehicle() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final plate = '${numberController.text.trim()} $selectedChar1$selectedChar2$selectedChar3';

    final vehicleData = {
      'plate': plate,
      'make': selectedMake,
      'model': selectedModel,
      'type': selectedType,
      'year': yearController.text,
      'color': selectedColor,
    };

    final vehicleRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('vehicles');

    if (widget.existingVehicle != null) {
      await vehicleRef.doc(widget.existingVehicle!.id).update(vehicleData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Машины мэдээлэл шинэчлэгдлээ")),
      );
    } else {
      await vehicleRef.add(vehicleData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Машин амжилттай нэмэгдлээ")),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingVehicle != null ? 'Машин засах' : 'Машин нэмэх'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Та улсын дугаараар хайж машин нэмнэ үү'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(labelText: 'Дугаар', counterText: ''),
                  ),
                ),
                const SizedBox(width: 8),
                _letterBox(selectedChar1, (val) => setState(() => selectedChar1 = val)),
                _letterBox(selectedChar2, (val) => setState(() => selectedChar2 = val)),
                _letterBox(selectedChar3, (val) => setState(() => selectedChar3 = val)),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMake,
              items: carManufacturers.keys.map((make) {
                return DropdownMenuItem(
                  value: make,
                  child: Text(make),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedMake = val!;
                  selectedModel = carManufacturers[selectedMake]!.keys.first;
                  selectedType = carManufacturers[selectedMake]![selectedModel]!;
                });
              },
              decoration: const InputDecoration(labelText: 'Үйлдвэрлэгч'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedModel,
              items: carManufacturers[selectedMake]!.keys.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedModel = val!;
                  selectedType = carManufacturers[selectedMake]![selectedModel]!;
                });
              },
              decoration: const InputDecoration(labelText: 'Марк / Загвар'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Төрөл: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(selectedType, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Үйлдвэрлэсэн он'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedColor,
              items: mongolianColors.map((color) {
                return DropdownMenuItem(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedColor = val),
              decoration: const InputDecoration(labelText: 'Өнгө'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveVehicle,
              child: Text(widget.existingVehicle != null ? 'Шинэчлэх' : 'Машин нэмэх'),
            )
          ],
        ),
      ),
    );
  }

  Widget _letterBox(String char, Function(String) onTap) {
    return GestureDetector(
      onTap: () => _showKeyboardPicker(onTap),
      child: Container(
        width: 40,
        height: 45,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(char, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
