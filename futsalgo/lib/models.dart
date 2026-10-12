class Lapangan {
  String id, nama, jenis, lokasi, fasilitas;
  int harga, buka, tutup;
  bool aktif;

  Lapangan({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.lokasi,
    required this.harga,
    this.buka = 8,
    this.tutup = 23,
    this.fasilitas = 'Toilet • Parkir • Kantin',
    this.aktif = true,
  });
}

class Akun {
  final String username,
      password,
      nama,
      hp,
      role; // role: 'admin' atau 'member'
  const Akun({
    required this.username,
    required this.password,
    required this.nama,
    required this.hp,
    required this.role,
  });
}

class Booking {
  final String kode, akun, nama, hp, metode;
  final Lapangan lapangan;
  final DateTime tanggal;
  final List<int> jam;
  final int total;

  Booking({
    required this.kode,
    required this.akun,
    required this.nama,
    required this.hp,
    required this.metode,
    required this.lapangan,
    required this.tanggal,
    required this.jam,
    required this.total,
  });
}
