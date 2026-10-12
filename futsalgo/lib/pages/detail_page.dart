import 'package:flutter/material.dart';
import '../helpers.dart';
import '../models.dart';
import '../store.dart';
import '../widgets.dart';
import 'payment_page.dart';

class DetailPage extends StatefulWidget {
  final Lapangan lap;
  const DetailPage({super.key, required this.lap});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int dayIdx = 0;
  final Set<int> picked = {};
  late final List<DateTime> days;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    days = List.generate(7, (i) => today.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.lap;
    final total = l.harga * picked.length;
    return Scaffold(
      appBar: AppBar(title: Text(l.nama)),
      body: ListView(
        children: [
          LapBanner(jenis: l.jenis, height: 150),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.nama,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.place, size: 16, color: Colors.black45),
                  const SizedBox(width: 4),
                  Text(l.lokasi, style: const TextStyle(color: Colors.black54)),
                ]),
                const SizedBox(height: 4),
                Text(l.fasilitas,
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 13)),
                const SizedBox(height: 20),
                const Text('Pilih Tanggal',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 76,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: days.length,
                    itemBuilder: (_, i) {
                      final sel = i == dayIdx;
                      final d = days[i];
                      return GestureDetector(
                        onTap: () => setState(() {
                          dayIdx = i;
                          picked.clear();
                        }),
                        child: Container(
                          width: 62,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: sel ? kHijau : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: sel ? kHijau : Colors.black12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(hari[d.weekday - 1],
                                  style: TextStyle(
                                      color:
                                          sel ? Colors.white70 : Colors.black54,
                                      fontSize: 12)),
                              const SizedBox(height: 4),
                              Text('${d.day}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          sel ? Colors.white : Colors.black87)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Pilih Jam',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                const Text('Bisa pilih lebih dari satu jam',
                    style: TextStyle(color: Colors.black45, fontSize: 12)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [for (int h = l.buka; h < l.tutup; h++) slot(l, h)],
                ),
                const SizedBox(height: 14),
                Row(children: [
                  legend(Colors.white, 'Tersedia', border: true),
                  const SizedBox(width: 14),
                  legend(kHijau, 'Dipilih'),
                  const SizedBox(width: 14),
                  legend(Colors.grey.shade300, 'Terisi'),
                ]),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${picked.length} jam dipilih',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12)),
                    Text(rp(total),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              FilledButton(
                onPressed: picked.isEmpty
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentPage(
                                lap: l,
                                tanggal: days[dayIdx],
                                jam: picked.toList()..sort()),
                          ),
                        ),
                child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text('Lanjut Bayar')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget slot(Lapangan l, int h) {
    final booked = store.isBooked(l, days[dayIdx], h);
    final sel = picked.contains(h);
    return GestureDetector(
      onTap: booked
          ? null
          : () => setState(() {
                sel ? picked.remove(h) : picked.add(h);
              }),
      child: Container(
        width: 98,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: booked ? Colors.grey.shade300 : (sel ? kHijau : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: sel ? kHijau : Colors.black12),
        ),
        child: Center(
          child: Text(
            jamStr(h),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: booked
                  ? Colors.black38
                  : (sel ? Colors.white : Colors.black87),
              decoration: booked ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget legend(Color c, String t, {bool border = false}) => Row(children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(4),
              border: border ? Border.all(color: Colors.black26) : null),
        ),
        const SizedBox(width: 4),
        Text(t, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ]);
}
