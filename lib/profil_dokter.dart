import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilDokterPage extends StatelessWidget {
  const ProfilDokterPage({super.key});

  // Fungsi untuk membuka email
  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'arifrahmanphone@gmail.com',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  // Fungsi untuk membuka telepon
  void _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '0895-6168-33383',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── HEADER ───────────────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A3C92), Color(0xFF2196F3)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      width: 114,
                      height: 114,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF5CF00),
                          width: 5,
                        ),
                      ),
                      child: ClipOval(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1A3C92), Color(0xFF2196F3)],
                            ),
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(
                              "assets/images/dokter.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Dr. Arif Rahman, Sp.PD",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "FINASIM, FINEM, AIFO-K, FISQua",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Spesialis Penyakit Dalam & Terapi Regeneratif",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── 1. INFORMASI SINGKAT ─────────────────────────────────────
              buildCard(
                "Informasi Singkat",
                Column(
                  children: [
                    info(Icons.person, "Nama Dokter",
                        "dr. Arif Rahman, Sp.PD, FINASIM, FINEM, AIFO-K, FISQua"),
                    info(Icons.medical_services, "Spesialis",
                        "Spesialis Penyakit Dalam & Terapi Regeneratif"),
                    info(Icons.hourglass_bottom, "Pengalaman",
                        "10+ Tahun Pengalaman"),
                  ],
                ),
              ),

              // ── DESKRIPSI ──────────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.all(18),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Dr. Arif Rahman, Sp.PD, FINASIM, FINEM, AIFO-K, FISQua '
                  'Spesialis Penyakit Dalam berpengalaman lebih dari 10 tahun '
                  'dalam menangani berbagai penyakit dalam seperti diabetes, '
                  'hipertensi, penyakit jantung, gangguan pencernaan, hingga '
                  'penyakit autoimun. Dr. Arif Rahman telah membantu ribuan '
                  'pasien mendapatkan pelayanan kesehatan terbaik.\n\n'
                  'Beliau juga aktif mengembangkan terapi medis inovatif dan '
                  'pengobatan regeneratif dengan metode stem cell dan turunannya '
                  'seperti exosome serta secretome untuk mendukung penyembuhan '
                  'yang lebih optimal.\n\n'
                  'Dengan berbagai pelatihan nasional maupun internasional, serta '
                  'fellowship di bidang nutrisi, olahraga klinis, dan mutu layanan '
                  'kesehatan, Dr. Arif Rahman berkomitmen memberikan layanan '
                  'kesehatan yang komprehensif, personal, dan berstandar tinggi '
                  'bagi masyarakat.',
                  style: TextStyle(
                    height: 1.7,
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
              ),

              // ── 2. LAYANAN ───────────────────────────────────────────────
              buildTitle("Layanan"),
              layananCard("Geriatri", "Layanan kesehatan khusus untuk lansia"),
              layananCard("Osteoarthritis", "Perawatan nyeri sendi dan tulang"),
              layananCard("Diabetes", "Pengelolaan gula darah terpadu"),
              const SizedBox(height: 10),

              // ── 3. TENTANG DOKTER ────────────────────────────────────────
              buildCard(
                "Tentang Dokter",
                const Text(
                  'dr. Arif Rahman, Sp.PD, FINASIM, FINEM, AIFO-K, FISQua adalah '
                  'dokter spesialis penyakit dalam dengan pengalaman lebih dari 10 tahun '
                  'dalam menangani penyakit lansia (Geriatri), diabetes, hipertensi, '
                  'autoimun, gangguan pencernaan, serta pola makan sehat.\n\n'
                  'Beliau menyelesaikan pendidikan Kedokteran Umum di Universitas '
                  'Diponegoro (2014) dan melanjutkan Spesialis Penyakit Dalam di '
                  'Universitas Sebelas Maret (2021).\n\n'
                  'Selain praktik klinis, dr. Arif aktif mengembangkan terapi '
                  'regeneratif seperti Stem Cell dan Exosome, serta berkomitmen '
                  'memberikan pelayanan kesehatan yang komprehensif dan berbasis '
                  'bukti ilmiah terkini.\n\n'
                  'Saat ini berpraktik di RS Kusuma Ungaran dan RS UNIMUS Semarang, '
                  'serta merupakan anggota PAPDI dan REJASELINDO.\n\n'
                  'Dedikasi beliau adalah memberikan pelayanan kesehatan terbaik '
                  'dengan pendekatan humanis dan penuh kepedulian terhadap pasien.',
                  style: TextStyle(height: 1.6, fontSize: 14),
                ),
              ),

              // ── 4. SPESIALIS & KEAHLIAN ──────────────────────────────────
              buildTitle("Spesialis & Keahlian"),
              spesialisCard("🩺", "Penyakit Dalam Umum",
                  "Diagnosis dan tata laksana berbagai penyakit dalam secara komprehensif."),
              spesialisCard("❤️", "Hipertensi & Penyakit Jantung",
                  "Penanganan hipertensi, penyakit jantung koroner, dan pencegahan komplikasi kardiovaskular."),
              spesialisCard("🍽", "Gangguan Pencernaan",
                  "GERD, gastritis, penyakit hati, dan berbagai gangguan saluran cerna."),
              spesialisCard("🧬", "Penyakit Metabolik",
                  "Gangguan tiroid, obesitas, diabetes melitus, dan sindrom metabolik."),
              spesialisCard("🫁", "Penyakit Paru",
                  "Asma, PPOK, pneumonia, dan gangguan pernapasan lainnya."),
              spesialisCard("🛡", "Penyakit Autoimun",
                  "Lupus, rheumatoid arthritis, dan berbagai gangguan sistem imun."),

              // ── 5. RIWAYAT PEKERJAAN ─────────────────────────────────────
              buildTitle("Riwayat Pekerjaan"),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    timelineCard(
                      Icons.school,
                      "Pendidikan Kedokteran",
                      "1996 - 2002",
                      "Program Pendidikan Dokter Umum di Fakultas Kedokteran "
                          "Universitas Diponegoro, Semarang",
                    ),
                    timelineCard(
                      Icons.medical_services,
                      "Spesialis Penyakit Dalam",
                      "2003 - 2008",
                      "Pendidikan Spesialis Penyakit Dalam di Fakultas Kedokteran "
                          "Universitas Diponegoro, Semarang",
                    ),
                    timelineCard(
                      Icons.local_hospital,
                      "Dokter Spesialis Penyakit Dalam",
                      "2008 - 2015",
                      "Praktik sebagai dokter spesialis penyakit dalam di berbagai "
                          "rumah sakit di Semarang dan sekitarnya",
                    ),
                    timelineCard(
                      Icons.star,
                      "Konsultan Senior",
                      "2015 - Sekarang",
                      "Bekerja sebagai konsultan senior penyakit dalam, menangani "
                          "pasien, memberikan edukasi, dan aktif dalam organisasi "
                          "profesi IDI & PAPDI",
                      isLast: true,
                    ),
                  ],
                ),
              ),

              // ── 6. KEANGGOTAAN ORGANISASI PROFESI ────────────────────────
              buildTitle("Keanggotaan Organisasi Profesi"),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Dr. Arif Rahman aktif dalam berbagai organisasi profesi kedokteran",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ),
              ),
              organisasiCard("1", "APASL",
                  "Asian Pacific Association for the Study of the Liver"),
              organisasiCard("2", "ASPI", "Asosiasi Sel Punca Indonesia"),
              organisasiCard("3", "EFIM",
                  "European Federation of Internal Medicine"),
              organisasiCard("4", "ISSCA",
                  "International Stem Cell Regeneration Charity Organization"),
              organisasiCard("5", "KIPDI",
                  "Kolegium Ilmu Penyakit Dalam Indonesia"),
              organisasiCard("6", "Komite Sel Punca Nasional", ""),
              organisasiCard("7", "PAPDI",
                  "Perhimpunan Dokter Spesialis Penyakit Dalam Indonesia"),
              organisasiCard("8", "PERMATI",
                  "Perhimpunan Reumatologi Indonesia"),
              organisasiCard("9", "S.si", ""),

              const SizedBox(height: 20),

              // ── 7. FOOTER ──────────────────────────────────────────────────
              _buildFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─── WIDGET HELPERS ──────────────────────────────────────────────────────────

  Widget buildCard(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          child,
        ],
      ),
    );
  }

  Widget info(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1A3C92), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3C92))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3C92),
          ),
        ),
      ),
    );
  }

  Widget timelineCard(
    IconData icon,
    String title,
    String tahun,
    String isi, {
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF1A3C92),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                      width: 2, color: const Color(0xFFF5CF00)),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1A3C92))),
                  const SizedBox(height: 4),
                  Text(tahun,
                      style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(isi,
                      style: const TextStyle(
                          height: 1.5,
                          fontSize: 13,
                          color: Colors.black87)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget organisasiCard(String nomor, String nama, String namaLengkap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1A3C92),
            radius: 18,
            child: Text(nomor,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaLengkap.isNotEmpty ? namaLengkap : nama,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                const Text("✓  Anggota Aktif",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget layananCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3C92), Color(0xFF2196F3)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget spesialisCard(String emoji, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            constraints: const BoxConstraints(minHeight: 70),
            decoration: BoxDecoration(
              color: const Color(0xFFF5CF00),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1A3C92))),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(subtitle,
                    style: const TextStyle(
                        height: 1.5,
                        fontSize: 13,
                        color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── FOOTER WIDGET ──────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // JUDUL
          const Text(
            "Kontak & Sosial Media",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A3C92),
            ),
          ),
          const Divider(),
          
          // Facebook
          _buildFooterItem(FontAwesomeIcons.facebook, "@doktermimin"),
          // Instagram
          _buildFooterItem(FontAwesomeIcons.instagram, "@doktermimin"),
          // TikTok
          _buildFooterItem(FontAwesomeIcons.tiktok, "@simimin"),
          // Lokasi
          _buildFooterItem(Icons.location_on, "Kota Semarang"),
          // Email (bisa diklik)
          InkWell(
            onTap: _launchEmail,
            child: _buildFooterItem(Icons.email, "arifrahmanphone@gmail.com"),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A3C92), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A3C92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}