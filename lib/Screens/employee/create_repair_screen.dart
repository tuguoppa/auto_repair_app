import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateRepairScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const CreateRepairScreen({super.key, required this.user});

  @override
  _CreateRepairScreenState createState() => _CreateRepairScreenState();
}

class _CreateRepairScreenState extends State<CreateRepairScreen> {
  final TextEditingController issueController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController partsUsedController = TextEditingController();

  Future<void> _submitRepair() async {
    final issue = issueController.text.trim();
    final service = serviceController.text.trim();
    final partsUsed = partsUsedController.text.trim();

    if (issue.isEmpty || service.isEmpty || partsUsed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Бүх талбарыг бөглөнө үү.")),
      );
      return;
    }

    try {
      final uid = widget.user['id'];
      final now = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

      final historyRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('history');

      await historyRef.add({
        'issue': issue,
        'service': service,
        'parts': partsUsed,
        'date': now,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Засварын мэдээлэл хадгалагдлаа!")),
      );

      Navigator.pop(context);
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
              TextField(
                controller: serviceController,
                decoration: const InputDecoration(labelText: "Хийсэн үйлчилгээ"),
              ),
              TextField(
                controller: partsUsedController,
                decoration: const InputDecoration(labelText: "Ашигласан сэлбэгүүд"),
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
