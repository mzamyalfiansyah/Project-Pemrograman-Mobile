import 'package:flutter/material.dart';
import '../helpers.dart';
import '../models.dart';
import '../store.dart';
import '../widgets.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final list = store.lapangan.where((l) => l.aktif).toList();
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Halo, masbroo..',
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 4),
              const Text('Mau main di mana hari ini?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (list.isEmpty)
                const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text('Belum ada lapangan'))),
              ...list.map((l) => LapCard(l: l)),
            ],
          ),
        );
      },
    );
  }
}

class LapCard extends StatelessWidget {
  final Lapangan l;
  const LapCard({super.key, required this.l});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => DetailPage(lap: l))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: kartu(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            LapBanner(jenis: l.jenis),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.nama,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.place,
                              size: 14, color: Colors.black45),
                          const SizedBox(width: 2),
                          Expanded(
                              child: Text(l.lokasi,
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 13))),
                        ]),
                        const SizedBox(height: 4),
                        Text(
                            '${jamStr(l.buka)} - ${jamStr(l.tutup)} • ${l.jenis}',
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(rp(l.harga),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kHijau,
                              fontSize: 16)),
                      const Text('/ jam',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black45)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
