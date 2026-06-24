import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';
import 'kategori_penyakit.dart';

const int _kInitialVisible = 6;

class KategoriOrgan extends StatefulWidget {
  const KategoriOrgan({super.key});

  @override
  State<KategoriOrgan> createState() => _KategoriOrganState();
}

class _KategoriOrganState extends State<KategoriOrgan> {
  static const Color backgroundGrey = Color(0xFFEEF3FB);
  static const Color primaryBlue = Color(0xFF1A3C92);
  static const Color textDark = Color(0xFF1A3C92);
  static const Color textMedium = Color(0xFF6B7280);

  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  late Future<List<OrganItem>> _organFuture;
  List<OrganItem> _allOrgans = [];
  List<OrganItem> _filtered = [];
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _organFuture = _loadOrganList();
  }

  Future<List<OrganItem>> _loadOrganList() async {
    final organs = await _apiService.getOrganList();
    setState(() {
      _allOrgans = organs;
      _filtered = organs;
    });
    return organs;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = query.isEmpty
          ? _allOrgans
          : _allOrgans.where((o) {
              return o.nama.toLowerCase().contains(query.toLowerCase()) ||
                  o.deskripsi.toLowerCase().contains(query.toLowerCase());
            }).toList();
      _showAll = false;
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
              child: FutureBuilder<List<OrganItem>>(
                future: _organFuture,
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

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildGrid(),
                        if (_showToggle) _buildToggleButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
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
    final crossAxis = screenWidth < 360 ? 2 : 3;

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
            builder: (_) =>
                KategoriPenyakit(organId: item.id, namaOrgan: item.nama),
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
            Icon(_iconFromName(item.iconName), color: primaryBlue, size: 34),
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

  IconData _iconFromName(String iconName) {
    final key = iconName.toLowerCase();
    if (key.contains('heart')) return Icons.favorite_rounded;
    if (key.contains('water') || key.contains('drop'))
      return Icons.water_drop_rounded;
    if (key.contains('lung') || key.contains('air')) return Icons.air_rounded;
    if (key.contains('brain') || key.contains('otak'))
      return Icons.psychology_rounded;
    if (key.contains('bone') || key.contains('tulang'))
      return Icons.accessibility_new_rounded;
    if (key.contains('restaurant') || key.contains('pencernaan'))
      return Icons.restaurant_rounded;
    if (key.contains('blood') || key.contains('hati'))
      return Icons.bloodtype_rounded;
    if (key.contains('scale') || key.contains('esofagus'))
      return Icons.linear_scale_rounded;
    return Icons.medical_services_rounded;
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat kategori organ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Tidak ada kategori organ tersedia.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
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
