import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_helpers.dart';

class DetailPenyakit extends StatefulWidget {
  final PenyakitItem penyakit;

  const DetailPenyakit({super.key, required this.penyakit});

  @override
  State<DetailPenyakit> createState() => _DetailPenyakitState();
}

class _DetailPenyakitState extends State<DetailPenyakit> {
  late Future<PenyakitItem> _penyakitFuture;
  bool penyebab = false;
  bool gejala = false;
  bool bahaya = false;
  bool pengobatan = false;

  @override
  void initState() {
    super.initState();
    _penyakitFuture = _fetchPenyakitDetail();
  }

  Future<PenyakitItem> _fetchPenyakitDetail() async {
    try {
      final detail = await apiService.getPenyakitById(widget.penyakit.id);
      return detail ?? widget.penyakit;
    } catch (e) {
      debugPrint('DetailPenyakit - load error: $e');
      return widget.penyakit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<PenyakitItem>(
          future: _penyakitFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Gagal memuat detail penyakit: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final data = snapshot.data ?? widget.penyakit;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── TOMBOL KEMBALI ────────────────────────────────────────────
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.indigo),
                        SizedBox(width: 8),
                        Text(
                          "Kembali",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ── JUDUL ─────────────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.nama,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1A237E),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Detail Penyakit',
                              style: const TextStyle(color: Colors.indigo),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                data.organId.isNotEmpty
                                    ? 'Organ ID: ${data.organId}'
                                    : 'Detail Penyakit',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey.shade200,
                        child: Image.asset(
                          'assets/images/gerd.png',
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.medical_services, size: 40),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── DESKRIPSI ─────────────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xffF5EFD9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.indigo),
                    ),
                    child: Text(
                      data.deskripsi.isNotEmpty
                          ? data.deskripsi
                          : 'Deskripsi belum tersedia',
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ── GAMBAR ────────────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(child: _gambar("assets/images/g1.png")),
                      const SizedBox(width: 10),
                      Expanded(child: _gambar("assets/images/g2.png")),
                      const SizedBox(width: 10),
                      Expanded(child: _gambar("assets/images/g3.png")),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── ACCORDION: Penyebab, Gejala, Bahaya ───────────────────────
                  _expandTile(
                    "Penyebab Utama",
                    Icons.help,
                    Colors.blue,
                    penyebab,
                    () {},
                    data.penyebab.isNotEmpty ? data.penyebab : 'Belum tersedia',
                  ),

                  _expandTile(
                    "Gejala",
                    Icons.sentiment_satisfied,
                    Colors.orange,
                    gejala,
                    () {},
                    data.gejala.isNotEmpty ? data.gejala : 'Belum tersedia',
                  ),

                  _expandTile(
                    "Pengobatan",
                    Icons.medication,
                    Colors.teal,
                    pengobatan,
                    () {},
                    data.penanganan.isNotEmpty
                        ? data.penanganan
                        : 'Belum tersedia',
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── WIDGET HELPERS ──────────────────────────────────────────────────────────

  Widget _gambar(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        path,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 80,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image),
        ),
      ),
    );
  }

  /// ExpansionTile dengan isi berupa String (untuk Penyebab, Gejala, Bahaya)
  Widget _expandTile(
    String title,
    IconData icon,
    Color warna,
    bool buka,
    VoidCallback onTap,
    String isi,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        initiallyExpanded: buka,
        leading: CircleAvatar(
          backgroundColor: warna,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(padding: const EdgeInsets.all(15), child: Text(isi)),
        ],
      ),
    );
  }

  /// ExpansionTile dengan isi berupa List bullet
  /// — tampilan sama persis dengan _expandTile di atas
  Widget _expandTileList(String title, IconData icon, Color warna, List isi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: CircleAvatar(
          backgroundColor: warna,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: isi
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            style: TextStyle(
                              color: warna,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(child: Text(e.toString())),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
