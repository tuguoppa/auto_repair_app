import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'workshop_panel_screen.dart';

class CreateRepairScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const CreateRepairScreen({super.key, required this.user});

  @override
  _CreateRepairScreenState createState() => _CreateRepairScreenState();
}

class _CreateRepairScreenState extends State<CreateRepairScreen> {
  final TextEditingController issueController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  String? selectedService;
  String? selectedPartId;

  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> spareParts = [];

  @override
  void initState() {
    super.initState();
    _loadServices();
    _loadSpareParts();
  }

  Future<void> _loadServices() async {
    final snapshot = await FirebaseFirestore.instance.collection('services').get();
    setState(() {
      services = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _loadSpareParts() async {
    final sparepartsSnapshot = await FirebaseFirestore.instance.collection('spareparts').get();

    List<Map<String, dynamic>> allParts = [];

    for (final doc in sparepartsSnapshot.docs) {
      final categoryId = doc.id;
      final itemsSnapshot = await doc.reference.collection('items').get();

      for (final item in itemsSnapshot.docs) {
        final data = item.data();
        data['id'] = item.id;
        data['category'] = categoryId;
        allParts.add(data);
      }
    }

    setState(() {
      spareParts = allParts;
    });
  }

  Future<void> _submitRepair() async {
    final issue = issueController.text.trim();
    final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
    if (issue.isEmpty || selectedService == null || selectedPartId == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Бүх талбарыг зөв бөглөнө үү.")),
      );
      return;
    }

    try {
      final uid = widget.user['id'];
      final now = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
      final part = spareParts.firstWhere((e) => e['id'] == selectedPartId);
      final category = part['category'];
      final newQuantity = (part['quantity'] ?? 0) - quantity;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('history')
          .add({
        'issue': issue,
        'service': selectedService,
        'parts': part['name'],
        'usedQuantity': quantity,
        'date': now,
      });

      await FirebaseFirestore.instance
          .collection('spareparts')
          .doc(category)
          .collection('items')
          .doc(selectedPartId)
          .update({'quantity': newQuantity});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .add({
        'message': "Танд '$selectedService' үйлчилгээ амжилттай хийгдлээ.",
        'date': now,
        'isRead': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Засвар хадгалагдаж, мэдэгдэл илгээгдлээ!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WorkshopPanelScreen(name: '')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Алдаа гарлаа: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Засвар бүртгэх - ${user['firstName'] ?? 'Тодорхойгүй'}"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Машин: ${user['car'] ?? 'Мэдээлэл алга'}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              TextField(
                controller: issueController,
                decoration: const InputDecoration(labelText: "Гэмтэл/асуудал"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedService,
                items: services
                    .where((service) => service['name'] != null)
                    .map((service) => DropdownMenuItem<String>(
                          value: service['name'] as String,
                          child: Text(service['name']),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedService = val),
                decoration: const InputDecoration(labelText: "Үйлчилгээ"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedPartId,
                items: spareParts.map((part) {
                  return DropdownMenuItem<String>(
                    value: part['id'],
                    child: Text('${part['name']} (${part['quantity'] ?? 0})'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedPartId = val),
                decoration: const InputDecoration(labelText: "Сэлбэг"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Ашиглах тоо хэмжээ"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRepair,
                child: const Text("Хадгалах ба мэдэгдэл илгээх"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              )
            ],
          ),
        ),
      ),
    );
  }
}
