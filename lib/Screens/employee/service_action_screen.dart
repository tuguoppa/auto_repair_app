import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceActionScreen extends StatefulWidget {
  final String userId;

  const ServiceActionScreen({super.key, required this.userId});

  @override
  State<ServiceActionScreen> createState() => _ServiceActionScreenState();
}

class _ServiceActionScreenState extends State<ServiceActionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController issueController = TextEditingController();
  final TextEditingController partsController = TextEditingController();

  bool isSubmitting = false;

  Future<void> _submitService() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final serviceData = {
      'service': serviceController.text.trim(),
      'issue': issueController.text.trim(),
      'parts': partsController.text.trim(),
      'date': DateTime.now().toString().split(' ').first,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('history')
          .add(serviceData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Үйлчилгээ амжилттай хадгалагдлаа')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Алдаа: $e')));
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Үйлчилгээ оруулах"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: serviceController,
                decoration: const InputDecoration(
                  labelText: "Үйлчилгээний нэр",
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Үйлчилгээ оруулна уу'
                            : null,
              ),
              TextFormField(
                controller: issueController,
                decoration: const InputDecoration(
                  labelText: "Гэмтлийн тайлбар",
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Гэмтлийн мэдээлэл оруулна уу'
                            : null,
              ),
              TextFormField(
                controller: partsController,
                decoration: const InputDecoration(labelText: "Сэлбэг"),
              ),
              const SizedBox(height: 20),
              isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                    onPressed: _submitService,
                    icon: const Icon(Icons.check),
                    label: const Text("Хадгалах"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
