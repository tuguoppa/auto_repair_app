import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_select_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import '../employee/create_repair_screen.dart';
import 'add_vehicle_screen.dart';
import 'vehicle_list_screen.dart';
import 'user_history_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _bannerImages = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(const Duration(seconds: 2), (Timer timer) {
        if (!mounted) return;
        setState(() {
          _currentPage = (_currentPage + 1) % _bannerImages.length;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Repair System'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.car_repair, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'XX Auto Center',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            buildDrawerItem(Icons.person, 'Хувийн мэдээлэл', context, ProfileScreen()),
            buildDrawerItem(Icons.car_rental, 'Миний машинууд', context, VehicleListScreen(uid: uid)),
            buildDrawerItem(Icons.history, 'Үйлчилгээний түүх', context, UserHistoryScreen(user: widget.user)),
            buildDrawerItem(Icons.card_giftcard, 'Урамшуулал', context, null),
            buildDrawerItem(Icons.info_outline, 'Бидний тухай', context, null),
            buildDrawerItem(Icons.rule_folder, 'Үйлчилгээний нөхцөл', context, null),
            buildDrawerItem(Icons.help_outline, 'Тусламж', context, null),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.blue),
              title: const Text('Гарах'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginSelectScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddCarButton(context),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _bannerImages.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(_bannerImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Үйлчилгээ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              children: const [
                ServiceTile(icon: Icons.build, label: 'Сэгсэрдэг оношилгоо'),
                ServiceTile(icon: Icons.cleaning_services, label: 'Авто доторлогоо'),
                ServiceTile(icon: Icons.lightbulb, label: 'Авто гэрэл тохиргоо'),
                ServiceTile(icon: Icons.oil_barrel, label: 'Тос солих'),
                ServiceTile(icon: Icons.computer, label: 'Компьютер оношилгоо'),
                ServiceTile(icon: Icons.settings, label: 'Явах эд анги'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(IconData icon, String title, BuildContext context, Widget? screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: screen != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen))
          : () {},
    );
  }

  Widget _buildAddCarButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.directions_car, color: Colors.orange),
            SizedBox(height: 5),
            Text('Машин нэмэх', style: TextStyle(color: Colors.indigo)),
          ],
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const ServiceTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.blueAccent),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
