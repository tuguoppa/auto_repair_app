import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Бүртгэл амжилттай!')),
        );

        Navigator.pop(context); // Login руу буцах
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Алдаа: ${e.message}')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Keyboard гархад UI дээшлэх
      appBar: AppBar(
        title: const Text("Бүртгүүлэх"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView( // ✅ Scroll хийх боломж нэмэгдэнэ
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 60),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Имэйл'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Имэйл оруулна уу';
                  if (!value.contains('@')) return 'Зөв имэйл оруулна уу';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Нууц үг'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Нууц үг оруулна уу';
                  if (value.length < 6) return 'Хамгийн багадаа 6 тэмдэгт!';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("Бүртгүүлэх"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
