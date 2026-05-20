import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'jadwal_praktek/jadwal_praktek.dart';
import 'kesehatan/kategori_organ.dart';
import 'pelayanan/pelayanan.dart';

void main() {
  runApp(const MyApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN APP
// ─────────────────────────────────────────────────────────────────────────────

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduHealth',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
        ),
      ),

      home: const MainShell(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SHELL
// ─────────────────────────────────────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // ─── Daftar Halaman ───────────────────────────────────────────────────────

  final List<Widget> _pages = const [
    BerandaPlaceholder(), // index 0
    JadwalPraktek(), // index 1
    KategoriOrgan(), // index 2
    Pelayanan(), // index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: EduHealthBottomNav(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER BERANDA
// ─────────────────────────────────────────────────────────────────────────────

class BerandaPlaceholder extends StatelessWidget {
  const BerandaPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Beranda\n(Akan diisi tim lain)',
          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}