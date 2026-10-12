import 'package:flutter/material.dart';
import '../helpers.dart';
import '../models.dart';
import '../store.dart';
import '../widgets.dart';
import 'konfirmasi_page.dart';

class PaymentPage extends StatefulWidget {
  final Lapangan lap;
  final DateTime tanggal;
  final List<int> jam;
  const PaymentPage(
      {super.key, required this.lap, required this.tanggal, required this.jam});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final nama = TextEditingController(text: store.user?.nama ?? '');
  final hp = TextEditingController(text: store.user?.hp ?? '');
  String metode = 'QRIS';
  final metodeList = const {
    'QRIS': Icons.qr_code_2,
    'Transfer Bank (BCA)': Icons.account_balance,
    'GoPay': Icons.account_balance_wallet,
    'OVO': Icons.account_balance_wallet_outlined,
  };

  @override
  void dispose() {
    nama.dispose();
    hp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.lap.harga * widget.jam.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: kartu(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ringkasan Pesanan',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(height: 20),
                infoRow('Lapangan', widget.lap.nama),
                infoRow('Tanggal', tgl(widget.tanggal)),
                infoRow('Jam', daftarJam(widget.jam)),
                infoRow('Harga/jam', rp(widget.lap.harga)),
                const Divider(height: 20),
                infoRow('Total', rp(total), bold: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: kartu(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Data Penyewa',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: nama,
                  decoration: const InputDecoration(
                      labelText: 'Nama lengkap',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hp,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      labelText: 'No. HP',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: kartu(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Metode Pembayaran',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                ...metodeList.entries.map((e) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(e.value, color: kHijau),
                      title: Text(e.key),
                      trailing: Icon(
                        metode == e.key
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: metode == e.key ? kHijau : Colors.black38,
                      ),
                      onTap: () => setState(() => metode = e.key),
                    )),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: () {
              if (nama.text.trim().isEmpty || hp.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Nama dan No. HP wajib diisi')));
                return;
              }
              final b = store.tambahBooking(
                lap: widget.lap,
                tanggal: widget.tanggal,
                jam: widget.jam,
                akun: store.user!.username,
                nama: nama.text.trim(),
                hp: hp.text.trim(),
                metode: metode,
              );
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => KonfirmasiPage(b: b)));
            },
            child: Text('Bayar ${rp(total)}'),
          ),
        ),
      ),
    );
  }
}
