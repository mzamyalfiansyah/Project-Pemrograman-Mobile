import 'package:flutter/material.dart';
import 'helpers.dart';
import 'store.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/riwayat_page.dart';
import 'pages/profil_page.dart';
import 'pages/admin_page.dart';

void main() => runApp(const GoFutsalApp());

class GoFutsalApp extends StatelessWidget {
  const GoFutsalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoFutsal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kHijau),
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
      ),
      // Halaman ditentukan oleh status login dan peran
      home: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final u = store.user;
          if (u == null) return const LoginPage();
          if (u.role == 'admin') return const AdminPage();
          return const MemberShell();
        },
      ),
    );
  }
}

class MemberShell extends StatefulWidget {
  const MemberShell({super.key});

  @override
  State<MemberShell> createState() => _MemberShellState();
}

class _MemberShellState extends State<MemberShell> {
  int idx = 0;
  final pages = const [HomePage(), RiwayatPage(), ProfilPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: idx, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i) => setState(() => idx = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded), label: 'Booking Saya'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
