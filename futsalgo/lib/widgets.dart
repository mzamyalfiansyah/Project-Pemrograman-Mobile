import 'package:flutter/material.dart';
import 'helpers.dart';
import 'models.dart';

class LapBanner extends StatelessWidget {
  final String jenis;
  final double height;
  const LapBanner({super.key, required this.jenis, this.height = 110});

  @override
  Widget build(BuildContext context) {
    final c = warnaJenis(jenis);
    return Container(
      height: height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [c, c.withOpacity(0.6)])),
      child: Center(
          child: Icon(iconJenis(jenis),
              size: height * 0.5, color: Colors.white70)),
    );
  }
}

Widget infoRow(String a, String b, {bool bold = false}) {
  final st = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 16 : 14);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(a, style: st.copyWith(color: bold ? null : Colors.black54)),
        const SizedBox(width: 16),
        Expanded(child: Text(b, textAlign: TextAlign.right, style: st)),
      ],
    ),
  );
}

BoxDecoration kartu() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4))
      ],
    );

class BookingTile extends StatelessWidget {
  final Booking b;
  final VoidCallback? onCancel;
  const BookingTile({super.key, required this.b, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: kartu(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconJenis(b.lapangan.jenis),
                  color: warnaJenis(b.lapangan.jenis)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(b.lapangan.nama,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('Lunas',
                    style: TextStyle(
                        color: kHijau,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 20),
          infoRow('Kode', b.kode),
          infoRow('Penyewa', b.nama),
          infoRow('Tanggal', tgl(b.tanggal)),
          infoRow('Jam', daftarJam(b.jam)),
          infoRow('Total', rp(b.total), bold: true),
          if (onCancel != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                label:
                    const Text('Batalkan', style: TextStyle(color: Colors.red)),
              ),
            ),
        ],
      ),
    );
  }
}
