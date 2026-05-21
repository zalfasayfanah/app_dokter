import 'package:flutter/material.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class JadwalItem {
  final String hari;
  final String jam;
  const JadwalItem({required this.hari, required this.jam});
}

class RumahSakitItem {
  final String nama;
  final String alamat;
  final String imageUrl;
  final List<JadwalItem> jadwal;

  const RumahSakitItem({
    required this.nama,
    required this.alamat,
    required this.imageUrl,
    required this.jadwal,
  });
}

// ─── Data (ganti dengan data dari API jika sudah ada) ────────────────────────

final List<RumahSakitItem> rumahSakitList = [
  RumahSakitItem(
    nama: 'RS UNIMUS',
    alamat: 'Jl. Kedungmundu No.214',
    imageUrl: 'https://placehold.co/120x90/2ecc71/ffffff?text=RS+UNIMUS',
    jadwal: const [
      JadwalItem(hari: 'Senin', jam: '08.00 - 12.00'),
      JadwalItem(hari: 'Selasa', jam: '08.00 - 12.00'),
      JadwalItem(hari: 'Rabu', jam: '08.00 - 12.00'),
    ],
  ),
  RumahSakitItem(
    nama: 'RS UNIMUS',
    alamat: 'Jl. Kedungmundu No.214',
    imageUrl: 'https://placehold.co/120x90/2ecc71/ffffff?text=RS+UNIMUS',
    jadwal: const [
      JadwalItem(hari: 'Senin', jam: '08.00 - 12.00'),
      JadwalItem(hari: 'Selasa', jam: '08.00 - 12.00'),
      JadwalItem(hari: 'Rabu', jam: '08.00 - 12.00'),
    ],
  ),
  RumahSakitItem(
    nama: 'RS UNIMUS',
    alamat: 'Jl. Kedungmundu No.214',
    imageUrl: 'https://placehold.co/120x90/2ecc71/ffffff?text=RS+UNIMUS',
    jadwal: const [
      JadwalItem(hari: 'Senin', jam: '08.00 - 12.00'),
      JadwalItem(hari: 'Selasa', jam: '08.00 - 12.00'),
      JadwalItem(hari: 'Rabu', jam: '08.00 - 12.00'),
    ],
  ),
  RumahSakitItem(
    nama: 'RS UNIMUS',
    alamat: 'Jl. Kedungmundu No.214',
    imageUrl: 'https://placehold.co/120x90/2ecc71/ffffff?text=RS+UNIMUS',
    jadwal: const [
      JadwalItem(hari: 'Senin', jam: '08.00 - 12.00'),
      JadwalItem(hari: 'Selasa', jam: '08.00 - 12.00'),
      JadwalItem(hari: 'Rabu', jam: '08.00 - 12.00'),
    ],
  ),
];

// ─── Screen ──────────────────────────────────────────────────────────────────

class JadwalPraktek extends StatelessWidget {
  const JadwalPraktek({super.key});

  static const Color primaryBlue    = Color(0xFF1A3C92);
  static const Color backgroundGrey = Color(0xFFF0F4FA);
  static const Color textDark       = Color(0xFF1A1A2E);
  static const Color textMedium     = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTitle(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Image.asset(
            'assets/images/Logo_eduhealth_2.png', // ← nama file harus sama persis
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Edu',
                  style: TextStyle(
                    color: Color(0xFF1A3C92),
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                TextSpan(
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

  // ── Title ──────────────────────────────────────────────────────────────────

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Text(
        'JADWAL PRAKTEK',
        style: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w900,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── List ───────────────────────────────────────────────────────────────────

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      itemCount: rumahSakitList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildCard(rumahSakitList[index]),
    );
  }

  // ── Card ───────────────────────────────────────────────────────────────────

  Widget _buildCard(RumahSakitItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHospitalImage(item.imageUrl),
                const SizedBox(width: 14),
                Expanded(child: _buildScheduleTable(item.jadwal)),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.local_hospital_rounded,
                    color: Color(0xFFFBBF24), size: 18),
                const SizedBox(width: 6),
                Text(
                  item.nama,
                  style: const TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    color: Color(0xFFEF4444), size: 16),
                const SizedBox(width: 6),
                Text(
                  item.alamat,
                  style: const TextStyle(
                    color: textMedium,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: 110,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 110,
          height: 90,
          color: const Color(0xFFD1FAE5),
          child: const Icon(Icons.local_hospital_rounded,
              color: Color(0xFF059669), size: 36),
        ),
      ),
    );
  }

  Widget _buildScheduleTable(List<JadwalItem> jadwal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: jadwal
          .map(
            (j) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    child: Text(
                      j.hari,
                      style: const TextStyle(
                        color: textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    j.jam,
                    style: const TextStyle(
                      color: textMedium,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}