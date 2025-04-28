import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login_select_screen.dart';
import 'workshop_panel_screen.dart';

class WorkshopLoginScreen extends StatefulWidget {
  @override
  _WorkshopLoginScreenState createState() => _WorkshopLoginScreenState();
}

class _WorkshopLoginScreenState extends State<WorkshopLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Бүх талбарыг бөглөнө үү')));
      return;
    }

    setState(() => isLoading = true);

    try {
      // Firebase authentication
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception('User ID олдсонгүй');

      // Firestore дээр staff эсэхийг шалгах
      final doc =
          await FirebaseFirestore.instance.collection('staffs').doc(uid).get();

      if (doc.exists) {
        final staffName = doc.data()?['name'] ?? 'Staff';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WorkshopPanelScreen(name: staffName),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ажилтнаар амжилттай нэвтэрлээ!')),
        );
      } else {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Энэ бүртгэл staff биш байна')));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Алдаа: ${e.message}')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Алдаа гарлаа: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Засварын ажилтан нэвтрэх"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Workshop Login",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Имэйл"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Нууц үг"),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _login,
                  child: Text("Нэвтрэх"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
          ],
        ),
      ),
    );
  }
}
