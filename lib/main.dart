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
// BERANDA PROFILE DOKTER
// ─────────────────────────────────────────────────────────────────────────────

class BerandaPlaceholder extends StatelessWidget {
  const BerandaPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // HEADER
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,

              children: [

                Container(
                  height: 240,
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff1A237E),
                        Color(0xff3F7DFF),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

               // FOTO DOKTER
Positioned(
  bottom: -80,
  left: 0,
  right: 0,

  child: Center(
    child: Container(
      width: 150, // diperbesar
      height: 150,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFBBF24), // kuning

        border: Border.all(
          color: Colors.white,
          width: 4,
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0,4),
          )
        ],
      ),

      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(4),

          child: Image.asset(
            "assets/images/dokter.png",
            fit: BoxFit.cover,
            width: 140,
            height: 140,
          ),
        ),
      ),
    ),
  ),
),

],

),

const SizedBox(height: 100),

            // CARD BESAR
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: const Color(0xffE7E9F2),
                borderRadius: BorderRadius.circular(30),
              ),

              child: Column(
                children: [

                  const Text(
                    "Dr. Arif Rahman, Sp.PD, FINASIM,\nFINEM, AIFO-K, FISQua",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff233A8B),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Spesialis Penyakit Dalam",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // INFORMASI
                  _buildCard(
                    "Informasi",

                    Column(
                      children: [

                        _buildInfo(
                          Icons.person,
                          "Nama Lengkap",
                          "dr. Arif Rahman, Sp.PD",
                        ),

                        _buildInfo(
                          Icons.school,
                          "Pendidikan",
                          "Universitas Diponegoro",
                        ),

                        _buildInfo(
                          Icons.business,
                          "Tempat Praktik",
                          "RS Unimus",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TENTANG DOKTER
                  _buildCard(
                    "Tentang Dokter",

                    const Text(
                      "Dokter Arif Rahman adalah spesialis penyakit dalam yang berpengalaman dalam menangani berbagai penyakit sistem pencernaan, ginjal dan metabolik.",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SPESIALIS
                  _buildCard(
                    "Spesialis Keahlian",

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,

                      children: [

                        _skillChip(
                          Icons.medical_services,
                          "Penyakit dalam Umum",
                        ),

                        _skillChip(
                          Icons.favorite,
                          "Hipertensi dan jantung",
                        ),

                        _skillChip(
                          Icons.restaurant,
                          "Gangguan Pencernaan",
                        ),

                        _skillChip(
                          Icons.bubble_chart,
                          "Penyakit Metabolik",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: const Color(0xff233A8B),
            size: 24,
          ),

          const SizedBox(width: 15),

          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,

              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      String title,
      Widget child,
      ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Divider(),

          child,
        ],
      ),
    );
  }

  Widget _skillChip(
      IconData icon,
      String text,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),

        border: Border.all(
          color: Colors.grey.shade300,
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
          )
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 18,
            color: Colors.pink,
          ),

          const SizedBox(width: 6),

          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}