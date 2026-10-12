import 'package:flutter/material.dart';
import 'models.dart';
import 'helpers.dart';

class AppStore extends ChangeNotifier {
  int _no = 1000;

  // ---------- AKUN & LOGIN (data contoh) ----------
  final List<Akun> akunList = const [
    Akun(
        username: 'admin',
        password: 'admin123',
        nama: 'Admin GoFutsal',
        hp: '0812345678910',
        role: 'admin'),
    Akun(
        username: 'user',
        password: 'user123',
        nama: 'Mas Joko',
        hp: '0812345678910',
        role: 'member'),
  ];

  Akun? user; // null = belum login

  bool login(String username, String password) {
    final cocok = akunList
        .where((a) => a.username == username.trim() && a.password == password)
        .toList();
    if (cocok.isEmpty) return false;
    user = cocok.first;
    notifyListeners();
    return true;
  }

  void logout() {
    user = null;
    notifyListeners();
  }

  // ---------- LAPANGAN & BOOKING ----------
  final List<Lapangan> lapangan = [
    Lapangan(
        id: '1',
        nama: 'Lapangan A - Vinyl',
        jenis: 'Futsal',
        lokasi: 'Kemang, Jakarta Selatan',
        harga: 150000),
    Lapangan(
        id: '2',
        nama: 'Lapangan B - Sintetis',
        jenis: 'Futsal',
        lokasi: 'Tebet, Jakarta Selatan',
        harga: 130000),
    Lapangan(
        id: '3',
        nama: 'Lapangan C - Interlok',
        jenis: 'Futsal',
        lokasi: 'Cilandak, Jakarta Selatan',
        harga: 120000),
    Lapangan(
        id: '4',
        nama: 'Lapangan D - Vinyl',
        jenis: 'Futsal',
        lokasi: 'Senayan, Jakarta Pusat',
        harga: 160000,
        buka: 10,
        tutup: 22),
  ];
  final List<Booking> bookings = [];

  // Slot dianggap terisi jika ada booking asli ATAU slot "dummy" agar UI terlihat hidup
  bool isBooked(Lapangan l, DateTime t, int jam) {
    final dummy = (t.day + jam + l.nama.length) % 6 == 0;
    final real = bookings.any((b) =>
        b.lapangan.id == l.id && sameDay(b.tanggal, t) && b.jam.contains(jam));
    return dummy || real;
  }

  Booking tambahBooking({
    required Lapangan lap,
    required DateTime tanggal,
    required List<int> jam,
    required String akun,
    required String nama,
    required String hp,
    required String metode,
  }) {
    _no++;
    final b = Booking(
      kode: 'GF-$_no',
      akun: akun,
      nama: nama,
      hp: hp,
      metode: metode,
      lapangan: lap,
      tanggal: tanggal,
      jam: jam,
      total: lap.harga * jam.length,
    );
    bookings.add(b);
    notifyListeners();
    return b;
  }

  void hapusBooking(Booking b) {
    bookings.remove(b);
    notifyListeners();
  }

  void tambahLapangan(Lapangan l) {
    lapangan.add(l);
    notifyListeners();
  }

  void ubahLapangan() => notifyListeners();

  void hapusLapangan(Lapangan l) {
    lapangan.remove(l);
    notifyListeners();
  }
}

final store = AppStore();
