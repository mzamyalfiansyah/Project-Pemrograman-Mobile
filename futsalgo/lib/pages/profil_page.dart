import 'package:flutter/material.dart';
import '../helpers.dart';
import '../store.dart';
import '../widgets.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final u = store.user!;
    final jumlah = store.bookings.where((b) => b.akun == u.username).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: kHijau,
              child: Text(u.nama[0].toUpperCase(),
                  style: const TextStyle(fontSize: 36, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          Center(
              child: Text(u.nama,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold))),
          const Center(
              child: Text('Member', style: TextStyle(color: Colors.black54))),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: kartu(),
            child: Column(
              children: [
                infoRow('Username', u.username),
                infoRow('No. HP', u.hp),
                infoRow('Total booking', '$jumlah kali'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: store.logout,
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
