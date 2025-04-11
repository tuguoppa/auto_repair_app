import 'package:flutter/material.dart';
import 'Screens/login_select_screen.dart';

void main() {
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
      home: const LoginSelectScreen(), // 👈 Энд сонголтын дэлгэцийг эхэллээ
    );
  }
}
