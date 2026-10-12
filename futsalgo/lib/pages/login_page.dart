import 'package:flutter/material.dart';
import '../helpers.dart';
import '../store.dart';
import '../widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = TextEditingController();
  final pass = TextEditingController();
  bool sembunyi = true;
  String? error;

  @override
  void dispose() {
    user.dispose();
    pass.dispose();
    super.dispose();
  }

  void masuk() {
    final ok = store.login(user.text, pass.text);
    if (!ok) setState(() => error = 'Username atau password salah');
    // Kalau berhasil, main.dart otomatis pindah ke halaman sesuai peran
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: kHijau,
                  child:
                      Icon(Icons.sports_soccer, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 16),
                const Text('GoFutsal',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Booking lapangan jadi mudah',
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: kartu(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Masuk',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),
                      TextField(
                        controller: user,
                        decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: pass,
                        obscureText: sembunyi,
                        onSubmitted: (_) => masuk(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(sembunyi
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () =>
                                setState(() => sembunyi = !sembunyi),
                          ),
                        ),
                      ),
                      if (error != null) ...[
                        const SizedBox(height: 10),
                        Text(error!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 13)),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14)),
                          onPressed: masuk,
                          child: const Text('Masuk'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
