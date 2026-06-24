# Panduan Integrasi API di Berbagai Halaman

Dokumentasi ini menunjukkan cara mengintegrasikan API Service ke berbagai halaman aplikasi.

---

## 1. Jadwal Praktik (SUDAH DIINTEGRASIKAN)

File: `lib/jadwal_praktek/jadwal_praktek.dart`

✅ **Status**: Sudah menggunakan API
- Fetch data dari `/api/jadwal-praktek`
- Menampilkan loading state
- Error handling

**Contoh:**
```dart
Widget _buildList() {
  return FutureBuilder<List<RumahSakitItem>>(
    future: _jadwalFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      // ... handle error & show data
    },
  );
}
```

---

## 2. Profil Dokter

File: `lib/profil_dokter.dart`

**Contoh Integrasi:**

```dart
import 'package:flutter/material.dart';
import 'models/api_models.dart';
import 'services/api_service.dart';

class ProfilDokterPage extends StatefulWidget {
  const ProfilDokterPage({super.key});

  @override
  State<ProfilDokterPage> createState() => _ProfilDokterPageState();
}

class _ProfilDokterPageState extends State<ProfilDokterPage> {
  late ApiService _apiService;
  late Future<ProfilDokter> _profilFuture;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _profilFuture = _apiService.getProfilDokter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: FutureBuilder<ProfilDokter>(
          future: _profilFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final profil = snapshot.data;
            if (profil == null) {
              return const Center(child: Text('Profil tidak ditemukan'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1A3C92), Color(0xFF2196F3)],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        CircleAvatar(
                          radius: 57,
                          backgroundColor: const Color(0xFFF5CF00),
                          child: Image.asset(
                            profil.fotoProfil,
                            width: 114,
                            height: 114,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          profil.nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profil.spesialisasi,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info Singkat
                  buildCard(
                    'Informasi Singkat',
                    Column(
                      children: [
                        info(Icons.person, 'Nama Dokter', profil.nama),
                        info(Icons.medical_services, 'Spesialisasi', profil.spesialisasi),
                        info(Icons.hourglass_bottom, 'Pengalaman', profil.pengalaman),
                      ],
                    ),
                  ),

                  // Sertifikat
                  if (profil.sertifikat.isNotEmpty)
                    buildCard(
                      'Sertifikat',
                      Column(
                        children: profil.sertifikat
                            .map((cert) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(cert),
                                ],
                              ),
                            ))
                            .toList(),
                      ),
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
}

Widget buildCard(String title, Widget content) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    ),
  );
}

Widget info(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(value),
          ],
        ),
      ],
    ),
  );
}
```

---

## 3. Kategori Organ

File: `lib/kesehatan/kategori_organ.dart`

**Contoh Integrasi:**

```dart
import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';
import 'kategori_penyakit.dart';

class KategoriOrgan extends StatefulWidget {
  const KategoriOrgan({super.key});

  @override
  State<KategoriOrgan> createState() => _KategoriOrganState();
}

class _KategoriOrganState extends State<KategoriOrgan> {
  late ApiService _apiService;
  late Future<List<OrganItem>> _organFuture;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _organFuture = _apiService.getOrganList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: SafeArea(
        child: FutureBuilder<List<OrganItem>>(
          future: _organFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final organList = snapshot.data ?? [];

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'KATEGORI ORGAN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C92),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: organList.length,
                    itemBuilder: (context, index) {
                      final organ = organList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  KategoriPenyakit(organId: organ.id),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite,
                                  size: 48,
                                  color: Color(int.parse(
                                      '0xFF${organ.iconName ?? 'FF0000'}'))),
                              const SizedBox(height: 8),
                              Text(
                                organ.nama,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

---

## 4. Kategori Penyakit (Berdasarkan Organ)

File: `lib/kesehatan/kategori_penyakit.dart`

**Contoh Integrasi:**

```dart
import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';
import 'detail_penyakit.dart';

class KategoriPenyakit extends StatefulWidget {
  final String organId;

  const KategoriPenyakit({
    super.key,
    required this.organId,
  });

  @override
  State<KategoriPenyakit> createState() => _KategoriPenyakitState();
}

class _KategoriPenyakitState extends State<KategoriPenyakit> {
  late ApiService _apiService;
  late Future<List<PenyakitItem>> _penyakitFuture;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _penyakitFuture = _apiService.getPenyakitByOrganId(widget.organId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penyakit'),
      ),
      body: FutureBuilder<List<PenyakitItem>>(
        future: _penyakitFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final penyakitList = snapshot.data ?? [];

          return ListView.builder(
            itemCount: penyakitList.length,
            itemBuilder: (context, index) {
              final penyakit = penyakitList[index];
              return ListTile(
                title: Text(penyakit.nama),
                subtitle: Text(penyakit.deskripsi),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPenyakit(penyakitId: penyakit.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## 5. Detail Penyakit

File: `lib/kesehatan/detail_penyakit.dart`

**Contoh Integrasi:**

```dart
import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';

class DetailPenyakit extends StatefulWidget {
  final String penyakitId;

  const DetailPenyakit({
    super.key,
    required this.penyakitId,
  });

  @override
  State<DetailPenyakit> createState() => _DetailPenyakitState();
}

class _DetailPenyakitState extends State<DetailPenyakit> {
  late ApiService _apiService;
  late Future<PenyakitItem?> _penyakitFuture;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _penyakitFuture = _apiService.getPenyakitById(widget.penyakitId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penyakit'),
      ),
      body: FutureBuilder<PenyakitItem?>(
        future: _penyakitFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final penyakit = snapshot.data;
          if (penyakit == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  penyakit.nama,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                buildSection('Deskripsi', penyakit.deskripsi),
                buildSection('Gejala', penyakit.gejala),
                buildSection('Penyebab', penyakit.penyebab),
                buildSection('Penanganan', penyakit.penanganan),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
```

---

## 6. Pelayanan

File: `lib/pelayanan/pelayanan.dart`

**Contoh Integrasi:**

```dart
class _PelayananState extends State<Pelayanan> {
  late ApiService _apiService;
  late Future<List<PelayananItem>> _pelayananFuture;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _pelayananFuture = _apiService.getPelayananList();
  }

  Widget _buildServicesGrid() {
    return FutureBuilder<List<PelayananItem>>(
      future: _pelayananFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final pelayananList = snapshot.data ?? [];

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
          itemCount: pelayananList.length,
          itemBuilder: (context, index) {
            final pelayanan = pelayananList[index];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    pelayanan.nama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${pelayanan.harga.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
```

---

## Tips Implementasi

### 1. Gunakan State Management (Opsional)

Untuk aplikasi yang lebih kompleks, pertimbangkan menggunakan:
- **Provider** (recommended)
- **GetX**
- **Riverpod**
- **Bloc**

```dart
// Contoh dengan Provider
class JadwalProvider extends ChangeNotifier {
  List<RumahSakitItem> _jadwal = [];
  bool _isLoading = false;

  List<RumahSakitItem> get jadwal => _jadwal;
  bool get isLoading => _isLoading;

  Future<void> fetchJadwal() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _jadwal = await ApiService().getJadwalPraktek();
    } catch (e) {
      print('Error: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
```

### 2. Implementasi Retry Logic

```dart
ElevatedButton(
  onPressed: () {
    setState(() {
      _jadwalFuture = _apiService.getJadwalPraktek();
    });
  },
  child: const Text('Coba Lagi'),
)
```

### 3. Caching Data (Optional)

Gunakan `shared_preferences` atau `hive` untuk cache:

```dart
// Simpan ke cache
final prefs = await SharedPreferences.getInstance();
await prefs.setString('jadwal', jsonEncode(jadwalList));

// Ambil dari cache
final cached = prefs.getString('jadwal');
if (cached != null) {
  final jadwalList = List.from(jsonDecode(cached));
}
```

---

## Checklist Implementasi

- [ ] Update `pubspec.yaml` dengan dependencies
- [ ] Buat folder `lib/services/`, `lib/models/`, `lib/config/`
- [ ] Buat `ApiService`, Models, dan Config
- [ ] Integrasikan ke jadwal_praktek.dart
- [ ] Integrasikan ke profil_dokter.dart
- [ ] Integrasikan ke kategori_organ.dart
- [ ] Integrasikan ke kategori_penyakit.dart
- [ ] Integrasikan ke detail_penyakit.dart
- [ ] Integrasikan ke pelayanan.dart
- [ ] Test semua endpoint
- [ ] Deploy backend API
- [ ] Update base URL di `api_config.dart`

---

**Last Updated:** June 2, 2026
