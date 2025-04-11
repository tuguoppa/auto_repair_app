// lib/screens/create_repair_screen.dart
import 'package:flutter/material.dart';

class CreateRepairScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  CreateRepairScreen({required this.user});

  @override
  _CreateRepairScreenState createState() => _CreateRepairScreenState();
}

class _CreateRepairScreenState extends State<CreateRepairScreen> {
  final TextEditingController issueController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController partsUsedController = TextEditingController();

  void _submitRepair() {
    final issue = issueController.text;
    final service = serviceController.text;
    final partsUsed = partsUsedController.text;

    if (issue.isEmpty || service.isEmpty || partsUsed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Бүх талбарыг бөглөнө үү.")),
      );
      return;
    }

    // TODO: Save to backend + send notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Засварын мэдээлэл хадгалагдлаа!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Засвар бүртгэх - ${user['name']}"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Машин: ${user['car']}", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              TextField(
                controller: issueController,
                decoration: InputDecoration(labelText: "Гэмтэл/асуудал"),
              ),
              TextField(
                controller: serviceController,
                decoration: InputDecoration(labelText: "Хийсэн үйлчилгээ"),
              ),
              TextField(
                controller: partsUsedController,
                decoration: InputDecoration(labelText: "Ашигласан сэлбэгүүд"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRepair,
                child: Text("Хадгалах ба мэдэгдэл илгээх"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              )
            ],
          ),
        ),
      ),
    );
  }
}