import 'package:flutter/material.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class PenyakitItem {
  final String nama;
  final String kategoriOrgan; // dipakai untuk filter

  const PenyakitItem({
    required this.nama,
    required this.kategoriOrgan,
  });
}

// ─── Data (ganti/tambah sesuai kebutuhan) ────────────────────────────────────
// kategoriOrgan harus sama persis dengan OrganItem.nama di kategori_organ.dart

final List<PenyakitItem> penyakitList = [
  // Paru-Paru
  const PenyakitItem(nama: 'Pneumonia',    kategoriOrgan: 'Paru-Paru'),
  const PenyakitItem(nama: 'Asma',         kategoriOrgan: 'Paru-Paru'),
  const PenyakitItem(nama: 'Bronkitis',    kategoriOrgan: 'Paru-Paru'),
  const PenyakitItem(nama: 'TBC',          kategoriOrgan: 'Paru-Paru'),
  const PenyakitItem(nama: 'PPOK',         kategoriOrgan: 'Paru-Paru'),
  const PenyakitItem(nama: 'Efusi Pleura', kategoriOrgan: 'Paru-Paru'),
  const PenyakitItem(nama: 'Emfisema',     kategoriOrgan: 'Paru-Paru'),
  const PenyakitItem(nama: 'Sinusitis',    kategoriOrgan: 'Paru-Paru'),
  const PenyakitItem(nama: 'Rinitis',      kategoriOrgan: 'Paru-Paru'),
  // Jantung
  const PenyakitItem(nama: 'Hipertensi',   kategoriOrgan: 'Jantung'),
  const PenyakitItem(nama: 'Aritmia',      kategoriOrgan: 'Jantung'),
  const PenyakitItem(nama: 'Gagal Jantung',kategoriOrgan: 'Jantung'),
  // Ginjal
  const PenyakitItem(nama: 'Batu Ginjal',  kategoriOrgan: 'Ginjal'),
  const PenyakitItem(nama: 'Gagal Ginjal', kategoriOrgan: 'Ginjal'),
  // Otak
  const PenyakitItem(nama: 'Stroke',       kategoriOrgan: 'Otak'),
  const PenyakitItem(nama: 'Epilepsi',     kategoriOrgan: 'Otak'),
  const PenyakitItem(nama: 'Migrain',      kategoriOrgan: 'Otak'),
  // Hati
  const PenyakitItem(nama: 'Hepatitis A',  kategoriOrgan: 'Hati'),
  const PenyakitItem(nama: 'Hepatitis B',  kategoriOrgan: 'Hati'),
  const PenyakitItem(nama: 'Sirosis',      kategoriOrgan: 'Hati'),
  // Usus
  const PenyakitItem(nama: 'Diare',        kategoriOrgan: 'Usus'),
  const PenyakitItem(nama: 'Kolitis',      kategoriOrgan: 'Usus'),
  // Pencernaan
  const PenyakitItem(nama: 'Maag',         kategoriOrgan: 'Pencernaan'),
  const PenyakitItem(nama: 'GERD',         kategoriOrgan: 'Pencernaan'),
  // Tulang
  const PenyakitItem(nama: 'Osteoporosis', kategoriOrgan: 'Tulang'),
  const PenyakitItem(nama: 'Artritis',     kategoriOrgan: 'Tulang'),
  // Esofagus
  const PenyakitItem(nama: 'Disfagia',     kategoriOrgan: 'Esofagus'),
  const PenyakitItem(nama: 'Refluks',      kategoriOrgan: 'Esofagus'),
];

// ─── Screen ──────────────────────────────────────────────────────────────────

class KategoriPenyakit extends StatefulWidget {
  /// Nama organ yang dipilih dari KategoriOrgan.
  /// Dipakai sebagai judul sub-kategori & filter penyakit.
  final String namaOrgan;

  const KategoriPenyakit({super.key, required this.namaOrgan});

  @override
  State<KategoriPenyakit> createState() => _KategoriPenyakitState();
}

class _KategoriPenyakitState extends State<KategoriPenyakit> {
  static const Color backgroundGrey = Color(0xFFF0F4FA);
  static const Color primaryBlue    = Color(0xFF1A3A6B);
  static const Color accentYellow   = Color(0xFFF59E0B);
  static const Color textDark       = Color(0xFF1A1A2E);
  static const Color textMedium     = Color(0xFF6B7280);

  final TextEditingController _searchController = TextEditingController();
  late List<PenyakitItem> _byOrgan;
  late List<PenyakitItem> _filtered;

  @override
  void initState() {
    super.initState();
    _byOrgan  = penyakitList
        .where((p) => p.kategoriOrgan == widget.namaOrgan)
        .toList();
    _filtered = _byOrgan;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = query.isEmpty
          ? _byOrgan
          : _byOrgan
              .where((p) =>
                  p.nama.toLowerCase().contains(query.toLowerCase()))
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
            _buildHeader(context),
            _buildSearchBar(),
            _buildTitle(),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Tombol back ke Kategori Organ
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: primaryBlue, size: 20),
          ),
          const SizedBox(width: 12),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori Penyakit',
            style: TextStyle(
              color: textDark,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Penyakit ${widget.namaOrgan}',
            style: const TextStyle(
              color: textMedium,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ── Grid ───────────────────────────────────────────────────────────────────

  Widget _buildGrid() {
    if (_filtered.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada penyakit ditemukan.',
          style: TextStyle(color: textMedium),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: _filtered.length + 1, // +1 untuk tombol Lainnya
      itemBuilder: (context, index) {
        if (index == _filtered.length) return _buildLainnyaButton(context);
        return _buildPenyakitCard(context, _filtered[index]);
      },
    );
  }

  Widget _buildPenyakitCard(BuildContext context, PenyakitItem item) {
    return GestureDetector(
      onTap: () {
        // ── Navigasi ke Detail Penyakit ──────────────────────────────────────
        // Tim detail penyakit: buat file lib/kesehatan/detail_penyakit.dart
        // dengan class DetailPenyakit yang menerima parameter String namaPenyakit.
        //
        // Lalu aktifkan baris berikut (hapus komentar):
        //
        // import 'detail_penyakit.dart'; // tambahkan di bagian atas file ini
        //
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => DetailPenyakit(namaPenyakit: item.nama),
        //   ),
        // );
        //
        // Sementara ini tampilkan SnackBar sebagai penanda navigasi:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menuju detail: ${item.nama}'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentYellow, width: 2),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description_rounded,
                color: accentYellow, size: 32),
            const SizedBox(height: 8),
            Text(
              item.nama,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLainnyaButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: tampilkan semua penyakit untuk organ ini
      },
      child: Container(
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentYellow, width: 2),
        ),
        child: const Center(
          child: Text(
            'Lainnya',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}