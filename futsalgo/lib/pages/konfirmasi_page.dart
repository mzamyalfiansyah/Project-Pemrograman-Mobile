import 'package:flutter/material.dart';
import '../helpers.dart';
import '../models.dart';
import '../widgets.dart';

class KonfirmasiPage extends StatelessWidget {
  final Booking b;
  const KonfirmasiPage({super.key, required this.b});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                  radius: 44,
                  backgroundColor: kHijau,
                  child: Icon(Icons.check, color: Colors.white, size: 52)),
            ),
            const SizedBox(height: 20),
            const Center(
                child: Text('Booking Berhasil!',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            const SizedBox(height: 6),
            const Center(
                child: Text('Tunjukkan kode ini ke petugas venue',
                    style: TextStyle(color: Colors.black54))),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: kartu(),
              child: Column(
                children: [
                  Text(b.kode,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: kHijau)),
                  const Divider(height: 28),
                  infoRow('Lapangan', b.lapangan.nama),
                  infoRow('Tanggal', tgl(b.tanggal)),
                  infoRow('Jam', daftarJam(b.jam)),
                  infoRow('Penyewa', b.nama),
                  infoRow('Metode', b.metode),
                  const Divider(height: 28),
                  infoRow('Total Dibayar', rp(b.total), bold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}
