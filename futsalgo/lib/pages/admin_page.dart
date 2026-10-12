import 'package:flutter/material.dart';
import '../helpers.dart';
import '../models.dart';
import '../store.dart';
import '../widgets.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel Admin'),
          actions: [
            IconButton(
              tooltip: 'Keluar',
              icon: const Icon(Icons.logout),
              onPressed: store.logout,
            ),
          ],
          bottom: const TabBar(tabs: [
            Tab(text: 'Lapangan'),
            Tab(text: 'Booking'),
            Tab(text: 'Penyewa')
          ]),
        ),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) => TabBarView(children: [
            lapanganTab(context),
            bookingTab(),
            penyewaTab(),
          ]),
        ),
      ),
    );
  }

  Widget lapanganTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton.icon(
          onPressed: () => showLapanganForm(context),
          icon: const Icon(Icons.add),
          label: const Text('Tambah Lapangan'),
        ),
        const SizedBox(height: 12),
        ...store.lapangan.map((l) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: kartu(),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: warnaJenis(l.jenis),
                          child: Icon(iconJenis(l.jenis), color: Colors.white)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.nama,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '${rp(l.harga)}/jam • ${jamStr(l.buka)}-${jamStr(l.tutup)}',
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 13)),
                          ],
                        ),
                      ),
                      Switch(
                        value: l.aktif,
                        onChanged: (v) {
                          l.aktif = v;
                          store.ubahLapangan();
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => showLapanganForm(context, edit: l),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                      ),
                      TextButton.icon(
                        onPressed: () => konfirmasiHapus(context, l),
                        icon: const Icon(Icons.delete,
                            size: 18, color: Colors.red),
                        label: const Text('Hapus',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget bookingTab() {
    if (store.bookings.isEmpty) {
      return const Center(
          child: Text('Belum ada booking masuk',
              style: TextStyle(color: Colors.black45)));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: store.bookings.reversed
          .map((b) => BookingTile(b: b, onCancel: () => store.hapusBooking(b)))
          .toList(),
    );
  }

  Widget penyewaTab() {
    final map = <String, List<Booking>>{};
    for (final b in store.bookings) {
      map.putIfAbsent(b.nama, () => []).add(b);
    }
    if (map.isEmpty) {
      return const Center(
          child: Text('Belum ada penyewa',
              style: TextStyle(color: Colors.black45)));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: map.entries.map((e) {
        final totalBayar = e.value.fold<int>(0, (s, b) => s + b.total);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: kartu(),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: kHijau,
                child: Text(e.key[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white))),
            title: Text(e.key,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${e.value.first.hp} • ${e.value.length}x booking'),
            trailing: Text(rp(totalBayar),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: kHijau)),
          ),
        );
      }).toList(),
    );
  }

  void konfirmasiHapus(BuildContext context, Lapangan l) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus lapangan?'),
        content: Text('${l.nama} akan dihapus dari daftar.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              store.hapusLapangan(l);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void showLapanganForm(BuildContext context, {Lapangan? edit}) {
    final nama = TextEditingController(text: edit?.nama ?? '');
    final lokasi = TextEditingController(text: edit?.lokasi ?? '');
    final harga = TextEditingController(text: edit?.harga.toString() ?? '');
    String jenis = edit?.jenis ?? 'Futsal';
    int buka = edit?.buka ?? 8;
    int tutup = edit?.tutup ?? 23;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(edit == null ? 'Tambah Lapangan' : 'Edit Lapangan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nama,
                    decoration:
                        const InputDecoration(labelText: 'Nama lapangan')),
                TextField(
                    controller: lokasi,
                    decoration: const InputDecoration(labelText: 'Lokasi')),
                TextField(
                  controller: harga,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Harga per jam (Rp)'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: jenis,
                  decoration: const InputDecoration(labelText: 'Jenis'),
                  items: jenisList
                      .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                      .toList(),
                  onChanged: (v) => setS(() => jenis = v!),
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: buka,
                        decoration: const InputDecoration(labelText: 'Buka'),
                        items: [6, 7, 8, 9, 10, 11, 12]
                            .map((h) => DropdownMenuItem(
                                value: h, child: Text(jamStr(h))))
                            .toList(),
                        onChanged: (v) => setS(() => buka = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: tutup,
                        decoration: const InputDecoration(labelText: 'Tutup'),
                        items: [18, 19, 20, 21, 22, 23, 24]
                            .map((h) => DropdownMenuItem(
                                value: h, child: Text(jamStr(h))))
                            .toList(),
                        onChanged: (v) => setS(() => tutup = v!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal')),
            FilledButton(
              onPressed: () {
                if (nama.text.trim().isEmpty) return;
                final h = int.tryParse(harga.text) ?? 0;
                if (edit == null) {
                  store.tambahLapangan(Lapangan(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nama: nama.text.trim(),
                    jenis: jenis,
                    lokasi: lokasi.text.trim(),
                    harga: h,
                    buka: buka,
                    tutup: tutup,
                  ));
                } else {
                  edit.nama = nama.text.trim();
                  edit.lokasi = lokasi.text.trim();
                  edit.harga = h;
                  edit.jenis = jenis;
                  edit.buka = buka;
                  edit.tutup = tutup;
                  store.ubahLapangan();
                }
                Navigator.pop(ctx);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
