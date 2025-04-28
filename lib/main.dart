import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/login_select_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Firebase-ийг эхлүүлэхээс өмнө шаардлагатай
  await Firebase.initializeApp(); // Firebase-г инициализ хийх
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Repair App',
      theme: ThemeData(useMaterial3: true),
      home: const LoginSelectScreen(), // Сонголтын дэлгэц
    );
  }
}
