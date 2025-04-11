// lib/screens/customer_register_screen.dart
import 'package:flutter/material.dart';

class CustomerRegisterScreen extends StatefulWidget {
  @override
  _CustomerRegisterScreenState createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Backend бүртгэлтэй холбоно
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Бүртгэл амжилттай!')),
      );
      Navigator.pop(context); // login руу буцах
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Хэрэглэгч бүртгүүлэх"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Овог нэр"),
                  validator: (value) => value!.isEmpty ? "Овог нэр шаардлагатай" : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Утас"),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.length < 8 ? "Утасны дугаар буруу байна" : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Имэйл"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => !value!.contains('@') ? "Имэйл буруу байна" : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Нууц үг"),
                  validator: (value) => value!.length < 6 ? "Хамгийн багадаа 6 тэмдэгт" : null,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Нууц үг давтах"),
                  validator: (value) => value != _passwordController.text ? "Нууц үг таарахгүй байна" : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Бүртгүүлэх"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
