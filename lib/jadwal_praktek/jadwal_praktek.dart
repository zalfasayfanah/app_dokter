import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';

// ─── Screen ──────────────────────────────────────────────────────────────────

class JadwalPraktek extends StatefulWidget {
  const JadwalPraktek({super.key});

  @override
  State<JadwalPraktek> createState() => _JadwalPraktekState();
}

class _JadwalPraktekState extends State<JadwalPraktek> {
  late ApiService _apiService;
  late Future<List<RumahSakitItem>> _jadwalFuture;

  static const Color primaryBlue = Color(0xFF1A3C92);
  static const Color backgroundGrey = Color(0xFFF0F4FA);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _jadwalFuture = _apiService.getJadwalPraktek();
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
    return FutureBuilder<List<RumahSakitItem>>(
      future: _jadwalFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat jadwal praktik',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: textMedium),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _jadwalFuture = _apiService.getJadwalPraktek();
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 48, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada jadwal praktik',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        final jadwalList = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          itemCount: jadwalList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildCard(jadwalList[index]),
        );
      },
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
                const Icon(
                  Icons.local_hospital_rounded,
                  color: Color(0xFFFBBF24),
                  size: 18,
                ),
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
                const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFFEF4444),
                  size: 16,
                ),
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
          child: const Icon(
            Icons.local_hospital_rounded,
            color: Color(0xFF059669),
            size: 36,
          ),
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
                    style: const TextStyle(color: textMedium, fontSize: 13),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
