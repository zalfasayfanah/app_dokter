import 'package:flutter/material.dart';

class Pelayanan extends StatefulWidget {
  const Pelayanan({super.key});

  @override
  State<Pelayanan> createState() => _PelayananState();
}

class _PelayananState extends State<Pelayanan> {

  // ─── WARNA UTAMA ─────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF1A3C92);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    _buildPromoCard(),

                    const SizedBox(height: 24),

                    _buildSectionTitle(),

                    const SizedBox(height: 16),

                    _buildServicesGrid(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ──────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),

      child: Row(
        children: [
          Image.asset(
            'assets/images/Logo_eduhealth_2.png',
            width: 40,
            height: 40,
          ),

          const SizedBox(width: 10),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Edu',

                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),

                const TextSpan(
                  text: 'Health',

                  style: TextStyle(
                    color: Color(0xFFFBBF24),
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── PROMO CARD ──────────────────────────────────────────────

  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          const Text(
            'LAYANAN KESEHATAN DOKTER ARIF\nRAHMAN Sp.PD',

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A3C92),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 10),

          RichText(
            textAlign: TextAlign.left,

            text: const TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF555555),
                height: 1.7,
                fontFamily: 'Poppins',
              ),

              children: [
                TextSpan(
                  text:
                      'Dapatkan layanan kesehatan lengkap untuk Anda dan keluarga bersama dr. Arif Rahman. Mulai dari ',
                ),

                TextSpan(
                  text: 'Poliklinik Penyakit Dalam',

                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),

                TextSpan(
                  text: ' untuk pemeriksaan menyeluruh, Terapi ',
                ),

                TextSpan(
                  text: 'Stemcell',

                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),

                TextSpan(
                  text: ' untuk membantu regenerasi sel tubuh, ',
                ),

                TextSpan(
                  text: 'Home Care',

                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),

                TextSpan(
                  text: ' profesional yang nyaman di rumah Anda, hingga ',
                ),

                TextSpan(
                  text: 'Telekonsultasi',

                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),

                TextSpan(
                  text:
                      ' praktis yang bisa diakses kapan saja, di mana saja.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── JUDUL ───────────────────────────────────────────────────

  Widget _buildSectionTitle() {
    return const Center(
      child: Text(
        'Pelayanan',

        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A3C92),
        ),
      ),
    );
  }

  // ─── GRID PELAYANAN ──────────────────────────────────────────

  Widget _buildServicesGrid() {

    final List<_ServiceItem> services = [

      _ServiceItem(
        title: 'Poliklinik Spesialis\nPenyakit Dalam',
        imagePath: 'assets/images/poliklinik.jpeg',
        fallbackIcon: Icons.local_hospital_rounded,
        bgColor: const Color(0xFFD6E4F5),
      ),

      _ServiceItem(
        title: 'Terapi\nRegeneratif\n(Exosome & Secretome)',
        imagePath: 'assets/images/stemcell.jpeg',
        fallbackIcon: Icons.vaccines_rounded,
        bgColor: const Color(0xFFE0E0E0),
      ),

      _ServiceItem(
        title: 'Home Care\n(Via RS UNIMUS)',
        imagePath: 'assets/images/homecare.jpeg',
        fallbackIcon: Icons.home_rounded,
        bgColor: const Color(0xFFD1DFF0),
      ),

      _ServiceItem(
        title: 'Telekonsultasi\n(Via Humas RS UNIMUS)',
        imagePath: 'assets/images/telekonsultasi.jpeg',
        fallbackIcon: Icons.smartphone_rounded,
        bgColor: const Color(0xFFDEDEDE),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: services.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.88,
      ),

      itemBuilder: (context, index) {
        return _buildServiceCard(services[index]);
      },
    );
  }

  // ─── CARD PELAYANAN ──────────────────────────────────────────

  Widget _buildServiceCard(_ServiceItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 90,
            height: 90,

            decoration: BoxDecoration(
              color: item.bgColor,
              shape: BoxShape.circle,
            ),

            child: ClipOval(
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,

                errorBuilder: (_, __, ___) {
                  return Icon(
                    item.fallbackIcon,
                    color: primaryBlue,
                    size: 38,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            child: Text(
              item.title,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── MODEL DATA ────────────────────────────────────────────────

class _ServiceItem {

  final String title;
  final String imagePath;
  final IconData fallbackIcon;
  final Color bgColor;

  const _ServiceItem({
    required this.title,
    required this.imagePath,
    required this.fallbackIcon,
    required this.bgColor,
  });
}