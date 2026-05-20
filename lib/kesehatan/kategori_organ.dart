import 'package:flutter/material.dart';
import 'kategori_penyakit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

final List<OrganItem> organList = [
  const OrganItem(
    nama: 'Usus',
    deskripsi: 'Gangguan Pada Usus Saluran Pencernaan',
    icon: Icons.view_week_rounded,
  ),
  const OrganItem(
    nama: 'Ginjal',
    deskripsi: 'Masalah Ginjal dan Kantung Kemih',
    icon: Icons.water_drop_rounded,
  ),
  const OrganItem(
    nama: 'Jantung',
    deskripsi: 'Masalah Jantung, Pembuluh Darah dan Sirkulasi',
    icon: Icons.favorite_rounded,
  ),
  const OrganItem(
    nama: 'Pencernaan',
    deskripsi: 'Masalah Lambung dan Sistem Pencernaan',
    icon: Icons.restaurant_rounded,
  ),
  const OrganItem(
    nama: 'Hati',
    deskripsi: 'Gangguan Pada Hati, Empedu dan Pankreas',
    icon: Icons.bloodtype_rounded,
  ),
  const OrganItem(
    nama: 'Otak',
    deskripsi: 'Gangguan Pada Otak dan Saraf',
    icon: Icons.psychology_rounded,
  ),
  const OrganItem(
    nama: 'Tulang',
    deskripsi: 'Gangguan Tulang, Otot dan Sendi',
    icon: Icons.accessibility_new_rounded,
  ),
  const OrganItem(
    nama: 'Paru-Paru',
    deskripsi: 'Masalah Paru-paru dan Saluran Pernafasan',
    icon: Icons.air_rounded,
  ),
  const OrganItem(
    nama: 'Esofagus',
    deskripsi: 'Masalah Saluran Pernafasan',
    icon: Icons.linear_scale_rounded,
  ),
];

const int _kInitialVisible = 6;

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class KategoriOrgan extends StatefulWidget {
  const KategoriOrgan({super.key});

  @override
  State<KategoriOrgan> createState() => _KategoriOrganState();
}

class _KategoriOrganState extends State<KategoriOrgan> {
  static const Color backgroundGrey = Color(0xFFEEF3FB);
  static const Color primaryBlue    = Color(0xFF1A73E8); // ← sama dengan pelayanan
  static const Color textDark       = Color(0xFF1A1A2E);
  static const Color textMedium     = Color(0xFF6B7280);

  final TextEditingController _searchController = TextEditingController();

  List<OrganItem> _filtered = organList;
  bool _showAll = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = query.isEmpty
          ? organList
          : organList.where((o) {
              return o.nama.toLowerCase().contains(query.toLowerCase()) ||
                  o.deskripsi.toLowerCase().contains(query.toLowerCase());
            }).toList();
    });
  }

  List<OrganItem> get _visible {
    if (_showAll || _filtered.length <= _kInitialVisible) return _filtered;
    return _filtered.sublist(0, _kInitialVisible);
  }

  bool get _showToggle => _filtered.length > _kInitialVisible;

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildGrid(),
                    if (_showToggle) _buildToggleButton(),
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.white,
              size: 20,
            ),
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

  // ─── SEARCH BAR ──────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
            prefixIcon: Icon(Icons.search_rounded, color: Color(0xFFB0B8C1)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          ),
        ),
      ),
    );
  }

  // ─── TITLE ───────────────────────────────────────────────────

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

  // ─── GRID ────────────────────────────────────────────────────

  Widget _buildGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxis   = screenWidth < 360 ? 2 : 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _visible.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxis,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (_, index) => _buildOrganCard(_visible[index]),
      ),
    );
  }

  // ─── CARD ────────────────────────────────────────────────────

  Widget _buildOrganCard(OrganItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KategoriPenyakit(namaOrgan: item.nama),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: primaryBlue, size: 34),
            const SizedBox(height: 10),
            Text(
              item.nama,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                item.deskripsi,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: textMedium,
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TOMBOL LAINNYA / SEMBUNYIKAN ────────────────────────────

  Widget _buildToggleButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GestureDetector(
        onTap: () => setState(() => _showAll = !_showAll),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _showAll ? 'Sembunyikan' : 'Lainnya',
                style: const TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              AnimatedRotation(
                turns: _showAll ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: primaryBlue,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}