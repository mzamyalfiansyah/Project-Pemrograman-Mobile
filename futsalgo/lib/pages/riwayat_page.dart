import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final me = store.user?.username;
        final list = store.bookings
            .where((b) => b.akun == me)
            .toList()
            .reversed
            .toList();
        return Scaffold(
          appBar: AppBar(title: const Text('Booking Saya')),
          body: list.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_busy, size: 64, color: Colors.black26),
                      SizedBox(height: 8),
                      Text('Belum ada booking',
                          style: TextStyle(color: Colors.black45)),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: list.map((b) => BookingTile(b: b)).toList(),
                ),
        );
      },
    );
  }
}
