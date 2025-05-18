import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isEditing = false;
  String? photoUrl;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    emailController.text = user?.email ?? '';
  }

  Future<void> _pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final ref = FirebaseStorage.instance.ref().child('profile_pictures/${user!.uid}.jpg');

    await ref.putFile(file);
    final downloadURL = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'photoUrl': downloadURL,
    });

    setState(() {
      photoUrl = downloadURL;
      _selectedImage = file;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Зураг хадгалагдлаа")));
  }

  Future<void> _saveUserProfile() async {
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'lastName': lastNameController.text,
      'firstName': firstNameController.text,
      'phone': phoneController.text,
    }, SetOptions(merge: true));

    setState(() => isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Мэдээлэл хадгалагдлаа")),
    );
  }

  Future<void> _changePassword() async {
    try {
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPasswordController.text,
      );
      await user!.reauthenticateWithCredential(cred);
      await user!.updatePassword(newPasswordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Нууц үг амжилттай солигдлоо")),
      );

      currentPasswordController.clear();
      newPasswordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Алдаа: $e")));
    }
  }

  Future<void> _sendEmailVerification() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Баталгаажуулах имэйл илгээгдлээ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профайл"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveUserProfile();
              } else {
                setState(() => isEditing = true);
              }
            },
          )
        ],
      ),
      body: user == null
          ? const Center(child: Text("Хэрэглэгч олдсонгүй"))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Мэдээлэл олдсонгүй"));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;

                lastNameController.text = data['lastName'] ?? '';
                firstNameController.text = data['firstName'] ?? '';
                phoneController.text = data['phone'] ?? '';
                photoUrl = data['photoUrl'];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: isEditing ? _pickAndUploadImage : null,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (photoUrl != null
                                  ? NetworkImage(photoUrl!)
                                  : const AssetImage('assets/images/avatar.png')) as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: lastNameController,
                        enabled: isEditing,
                        decoration: const InputDecoration(labelText: "Овог"),
                      ),
                      TextField(
                        controller: firstNameController,
                        enabled: isEditing,
                        decoration: const InputDecoration(labelText: "Нэр"),
                      ),
                      TextField(
                        controller: emailController,
                        readOnly: true,
                        decoration: const InputDecoration(labelText: "Имэйл"),
                      ),
                      if (!user!.emailVerified)
                        TextButton(
                          onPressed: _sendEmailVerification,
                          child: const Text("📩 Имэйл баталгаажуулах"),
                        ),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        enabled: isEditing,
                        decoration: const InputDecoration(labelText: "Утас"),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const Text("🔐 Нууц үг солих", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: currentPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Одоогийн нууц үг"),
                      ),
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Шинэ нууц үг"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _changePassword,
                        child: const Text("Нууц үг солих"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
