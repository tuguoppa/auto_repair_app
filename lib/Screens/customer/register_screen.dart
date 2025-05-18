import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _register() async {
    final name = nameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Нууц үг таарахгүй байна")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        // Firebase Authentication бүртгэл
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final uid = userCredential.user!.uid;

        // Email баталгаажуулах
        if (!userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification();
        }

        // Нууц үг hashing (sha256)
        final hashedPassword = sha256.convert(utf8.encode(password)).toString();

        // Firestore-д хадгалах өгөгдөл
        final userData = {
          'firstName': name,
          'lastName': lastName,
          'phone': phone,
          'email': email,
          'passwordHash': hashedPassword,
          'photoUrl': '',
          'createdAt': Timestamp.now(),
        };

        try {
          await FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
        } catch (firestoreError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Firestore-д хадгалахад алдаа гарлаа: $firestoreError")),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Амжилттай бүртгэгдлээ! Имэйлээ баталгаажуулна уу.")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } on FirebaseAuthException catch (authError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Бүртгэх үед алдаа гарлаа: ${authError.message}")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Тодорхойгүй алдаа гарлаа: $e")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: _inputDecoration("First Name", Icons.person_outline),
                validator: (value) => value!.isEmpty ? "Нэр оруулна уу" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lastNameController,
                decoration: _inputDecoration("Last Name", Icons.person_outline),
                validator: (value) => value!.isEmpty ? "Овог оруулна уу" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: _inputDecoration("Phone", Icons.phone),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Утасны дугаар оруулна уу" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: _inputDecoration("Email", Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.contains('@') ? null : "Зөв имэйл оруулна уу",
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: _inputDecoration("Password", Icons.lock_outline),
                validator: (value) => value!.length >= 6 ? null : "Хамгийн багадаа 6 тэмдэгт",
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: _inputDecoration("Confirm Password", Icons.lock),
                validator: (value) => value == passwordController.text ? null : "Нууц үг таарахгүй байна",
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("SIGN UP", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text("Already have an account? Sign in"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
