import 'package:flutter/material.dart';

const kHijau = Color(0xFF1B8A4B);
const jenisList = ['Futsal'];
const hari = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
const bulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des'
];

String rp(int n) =>
    'Rp ${n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';

String jamStr(int h) => '${h.toString().padLeft(2, '0')}:00';

String tgl(DateTime d) =>
    '${hari[d.weekday - 1]}, ${d.day} ${bulan[d.month - 1]} ${d.year}';

String daftarJam(List<int> jam) {
  final s = [...jam]..sort();
  return s.map((h) => '${jamStr(h)}-${jamStr(h + 1)}').join(', ');
}

bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

IconData iconJenis(String j) {
  switch (j) {
    case 'Badminton':
      return Icons.sports_tennis;
    case 'Basket':
      return Icons.sports_basketball;
    default:
      return Icons.sports_soccer;
  }
}

Color warnaJenis(String j) {
  switch (j) {
    case 'Badminton':
      return const Color(0xFF1E6FD9);
    case 'Basket':
      return const Color(0xFFE8751A);
    default:
      return kHijau;
  }
}
