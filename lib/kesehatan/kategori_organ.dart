import 'package:flutter/material.dart';
import 'kategori_penyakit.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class OrganItem {
  final String nama;
  final String deskripsi;
  final IconData icon;

  const OrganItem({
    required this.nama,
    required this.deskripsi,
    required this.icon,
  });
}

// ─── Data (ganti/tambah sesuai kebutuhan) ────────────────────────────────────

final List<OrganItem> organList = [
  const OrganItem(
    nama: 'Usus',
    deskripsi: 'Gangguan Pada Usus Saluran Pencernaan',
    icon: Icons.animation_rounded,
  ),
  const OrganItem(
    nama: 'Ginjal',
    deskripsi: 'Masalah Ginjal dan kantung kemih',
    icon: Icons.water_drop_rounded,
  ),
  const OrganItem(
    nama: 'Jantung',
    deskripsi: 'Masalah Jantung, Pembuluh Darah dan silkurasi',
    icon: Icons.favorite_rounded,
  ),
  const OrganItem(
    nama: 'Pencernaan',
    deskripsi: 'Masalah Lambung dan masalah Pencernaan',
    icon: Icons.blur_circular_rounded,
  ),
  const OrganItem(
    nama: 'Hati',
    deskripsi: 'Gangguan Pada Hati, Empedu dan pankreas',
    icon: Icons.eco_rounded,
  ),
  const OrganItem(
    nama: 'Otak',
    deskripsi: 'Gangguan Pada Otak dan Saraf',
    icon: Icons.psychology_rounded,
  ),
  const OrganItem(
    nama: 'Tulang',
    deskripsi: 'Gangguan tulang, Otot dan Sendi',
    icon: Icons.accessibility_new_rounded,
  ),
  const OrganItem(
    nama: 'Paru-Paru',
    deskripsi: 'Masalah Paru-paru dan saluran pernafasan',
    icon: Icons.air_rounded,
  ),
  const OrganItem(
    nama: 'Esofagus',
    deskripsi: 'Masalah Saluran Pernafasan',
    icon: Icons.linear_scale_rounded,
  ),
];

// ─── Screen ──────────────────────────────────────────────────────────────────

class KategoriOrgan extends StatefulWidget {
  const KategoriOrgan({super.key});

  @override
  State<KategoriOrgan> createState() => _KategoriOrganState();
}

class _KategoriOrganState extends State<KategoriOrgan> {
  static const Color backgroundGrey = Color(0xFFF0F4FA);
  static const Color primaryBlue    = Color(0xFF1A3A6B);
  static const Color textDark       = Color(0xFF1A1A2E);
  static const Color textMedium     = Color(0xFF6B7280);

  final TextEditingController _searchController = TextEditingController();
  List<OrganItem> _filtered = organList;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = query.isEmpty
          ? organList
          : organList
              .where((o) =>
                  o.nama.toLowerCase().contains(query.toLowerCase()) ||
                  o.deskripsi.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTitle(),
            Expanded(child: _buildGrid()),
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.medical_services_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Edu',
                  style: TextStyle(
                    color: Color(0xFF1A73E8),
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                TextSpan(
                  text: 'Health',
                  style: TextStyle(
                    color: Color(0xFFF59E0B),
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

  // ── Search Bar ─────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearch,
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Color(0xFFB0B8C1), fontSize: 15),
            prefixIcon: Icon(Icons.search_rounded,
                color: Color(0xFFB0B8C1), size: 22),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          ),
        ),
      ),
    );
  }

  // ── Title ──────────────────────────────────────────────────────────────────

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Text(
        'Kategori Organ',
        style: TextStyle(
          color: textDark,
          fontWeight: FontWeight.w800,
          fontSize: 22,
        ),
      ),
    );
  }

  // ── Grid ───────────────────────────────────────────────────────────────────

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _filtered.length + 1, // +1 untuk tombol Lainnya
      itemBuilder: (context, index) {
        if (index == _filtered.length) return _buildLainnyaButton();
        return _buildOrganCard(_filtered[index]);
      },
    );
  }

  Widget _buildOrganCard(OrganItem item) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke Kategori Penyakit, kirim nama organ sebagai judul
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KategoriPenyakit(namaOrgan: item.nama),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: primaryBlue, size: 36),
            const SizedBox(height: 8),
            Text(
              item.nama,
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              item.deskripsi,
              style: const TextStyle(
                color: textMedium,
                fontSize: 10,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLainnyaButton() {
    return GestureDetector(
      onTap: () {
        // TODO: aksi tombol Lainnya (tampilkan semua organ, dll.)
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Center(
          child: Text(
            'Lainnya',
            style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}