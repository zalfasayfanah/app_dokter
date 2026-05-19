import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'jadwal_praktek/jadwal_praktek.dart';
import 'kesehatan/kategori_organ.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduHealth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A73E8)),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const MainShell(),
    );
  }
}

// ─── Shell utama: memegang state tab & menampilkan halaman aktif ──────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Daftar halaman sesuai urutan tab di EduHealthBottomNav
  // TODO: ganti BerandaPlaceholder dengan widget Beranda asli jika sudah siap
  final List<Widget> _pages = const [
    BerandaPlaceholder(),                // index 0 — diisi tim Beranda
    JadwalPraktek(),                     // index 1 — Jadwal Praktek
    KategoriOrgan(),                     // index 2 — Kesehatan
    PlaceholderPage(label: 'Profil'),    // index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: EduHealthBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// ─── Placeholder Beranda ──────────────────────────────────────────────────────
// Hapus class ini dan ganti referensinya di _pages[0]
// setelah widget Beranda dari tim lain sudah tersedia.

class BerandaPlaceholder extends StatelessWidget {
  const BerandaPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Beranda\n(akan diisi tim lain)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

// ─── Placeholder halaman lain yang belum dibuat ───────────────────────────────

class PlaceholderPage extends StatelessWidget {
  final String label;
  const PlaceholderPage({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}