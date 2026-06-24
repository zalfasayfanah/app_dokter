import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';
import 'detail_penyakit.dart';

const int _kInitialVisible = 6;

class KategoriPenyakit extends StatefulWidget {
  final String organId;
  final String namaOrgan;

  const KategoriPenyakit({
    super.key,
    required this.organId,
    required this.namaOrgan,
  });

  @override
  State<KategoriPenyakit> createState() => _KategoriPenyakitState();
}

class _KategoriPenyakitState extends State<KategoriPenyakit> {
  static const Color backgroundGrey = Color(0xFFF0F4FA);
  static const Color primaryBlue = Color(0xFF1A3C92);
  static const Color accentYellow = Color(0xFFFBBF24);
  static const Color textDark = Color(0xFF1A3C92);
  static const Color textMedium = Color(0xFF6B7280);
  static const Color navBlue = Color(0xFF1A3C92);

  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  late Future<List<PenyakitItem>> _penyakitFuture;
  List<PenyakitItem> _byOrgan = [];
  List<PenyakitItem> _filtered = [];
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _penyakitFuture = _loadPenyakit();
  }

  Future<List<PenyakitItem>> _loadPenyakit() async {
    final penyakit = await _apiService.getPenyakitByOrganId(widget.organId);
    setState(() {
      _byOrgan = penyakit;
      _filtered = penyakit;
    });
    return penyakit;
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
          : _byOrgan.where((p) {
              return p.nama.toLowerCase().contains(query.toLowerCase()) ||
                  p.deskripsi.toLowerCase().contains(query.toLowerCase());
            }).toList();
      _showAll = false;
    });
  }

  List<PenyakitItem> get _visible {
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
            _buildHeader(context),
            _buildSearchBar(),
            _buildTitle(),
            Expanded(
              child: FutureBuilder<List<PenyakitItem>>(
                future: _penyakitFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return _buildError(snapshot.error.toString());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmpty();
                  }

                  return _buildGrid();
                },
              ),
            ),
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: navBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
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
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Color(0xFFB0B8C1),
              size: 22,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
            style: const TextStyle(color: textMedium, fontSize: 14),
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

    final items = _visible;
    final itemCount = items.length + (_showToggle ? 1 : 0);

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (_showToggle && index == items.length) {
          return _buildLainnyaButton(context);
        }
        return _buildPenyakitCard(context, items[index]);
      },
    );
  }

  Widget _buildPenyakitCard(BuildContext context, PenyakitItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPenyakit(penyakit: item)),
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
            const Icon(
              Icons.description_rounded,
              color: accentYellow,
              size: 32,
            ),
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
        setState(() {
          _showAll = !_showAll;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentYellow, width: 2),
        ),
        child: Center(
          child: Text(
            _showAll ? 'Sembunyikan' : 'Lainnya',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat daftar penyakit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: textMedium),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Tidak ada penyakit tersedia untuk kategori ini.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
        ),
      ),
    );
  }
}
