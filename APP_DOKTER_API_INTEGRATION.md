# 🚀 APP_DOKTER - WebDokter API Integration Guide

Panduan lengkap untuk mengintegrasikan API WebDokter (yang sudah disetup) dengan Flutter project APP_DOKTER.

## 📊 Project Status

✅ **Flutter Project**: APP_DOKTER  
✅ **Backend API**: WebDokter (PHP Native)  
✅ **API Location**: `http://localhost/WebDokter/api`  
✅ **Database**: MySQL (WebDokter database)  

---

## 🔧 Step 1: Update API Configuration

Edit file `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // CHANGE THIS LINE - Update baseUrl ke localhost
  // BEFORE:
  // static const String baseUrl = 'http://192.168.18.153:8080/WebDokter/api';
  
  // AFTER:
  static const String baseUrl = 'http://localhost/WebDokter/api';

  // Endpoints untuk PHP native
  static const String jadwalPraktekEndpoint = '/jadwal_praktek.php';
  static const String profilDokterEndpoint = '/profil_dokter.php';
  static const String organEndpoint = '/organ.php';
  static const String penyakitEndpoint = '/penyakit.php';
  static const String pelayananEndpoint = '/pelayanan.php';

  // Timeout Duration
  static const Duration timeoutDuration = Duration(seconds: 30);
}
```

### ⚠️ Note untuk Android/iOS Development
Jika testing di emulator/device real:
- **Android Emulator**: `http://10.0.2.2/WebDokter/api`
- **iOS Simulator**: `http://localhost/WebDokter/api`
- **Device Real**: Ganti `localhost` dengan IP address XAMPP server

---

## 🔍 Step 2: Verifikasi API Connection

### Test 1: Check API Gateway
Buka di terminal:
```bash
curl http://localhost/WebDokter/api
```

Harus menampilkan JSON dengan dokumentasi API.

### Test 2: Check Endpoint
```bash
curl http://localhost/WebDokter/api/organ.php
```

Harus menampilkan data organ dengan format:
```json
{
  "success": true,
  "message": "Daftar organ berhasil diambil",
  "data": [...]
}
```

### Test 3: Test di Flutter
Jalankan app dengan Android emulator atau iOS simulator:
```bash
flutter run
```

Jika ada error koneksi, check:
1. XAMPP running
2. API config sudah benar
3. Firewall tidak blocking port 80

---

## 📱 Step 3: Update Models (jika perlu)

API WebDokter sudah mengembalikan format yang sesuai. Model yang ada di `lib/models/api_models.dart` sudah compatible.

### Verify Model untuk Organ
```dart
class OrganItem {
  final String id;
  final String nama;
  final String deskripsi;
  final String icon;
  final String warna;

  OrganItem({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.icon,
    required this.warna,
  });

  factory OrganItem.fromJson(Map<String, dynamic> json) {
    return OrganItem(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      icon: json['icon'] ?? '',
      warna: json['warna'] ?? '#000000',
    );
  }
}
```

### Verify Model untuk Penyakit
```dart
class PenyakitItem {
  final String id;
  final String nama;
  final String organNama;
  final String deskripsiSingkat;
  final String gambar;
  final String penyebabUtama;
  final String gejala;
  final String bahaya;
  final String caraMencegah;
  final String caraMengurangi;

  PenyakitItem({
    required this.id,
    required this.nama,
    required this.organNama,
    required this.deskripsiSingkat,
    required this.gambar,
    required this.penyebabUtama,
    required this.gejala,
    required this.bahaya,
    required this.caraMencegah,
    required this.caraMengurangi,
  });

  factory PenyakitItem.fromJson(Map<String, dynamic> json) {
    return PenyakitItem(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      organNama: json['organ_nama'] ?? '',
      deskripsiSingkat: json['deskripsi_singkat'] ?? '',
      gambar: json['gambar'] ?? '',
      penyebabUtama: json['penyebab_utama'] ?? '',
      gejala: json['gejala'] ?? '',
      bahaya: json['bahaya'] ?? '',
      caraMencegah: json['cara_mencegah'] ?? '',
      caraMengurangi: json['cara_mengurangi'] ?? '',
    );
  }
}
```

---

## 🎨 Step 4: Update UI Screens

### A. Kategori Organ Screen (`lib/kesehatan/kategori_organ.dart`)

File sudah menggunakan API dengan benar:
```dart
final ApiService _apiService = ApiService();

Future<List<OrganItem>> _loadOrganList() async {
  final organs = await _apiService.getOrganList();
  setState(() {
    _allOrgans = organs;
    _filtered = organs;
  });
  return organs;
}
```

✅ **Ini sudah bekerja dengan API yang disetup!**

### B. Detail Penyakit Screen (`lib/kesehatan/detail_penyakit.dart`)

Update untuk consume detail API:
```dart
import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';

class DetailPenyakit extends StatefulWidget {
  final String penyakitId;
  
  const DetailPenyakit({required this.penyakitId, super.key});

  @override
  State<DetailPenyakit> createState() => _DetailPenyakitState();
}

class _DetailPenyakitState extends State<DetailPenyakit> {
  final ApiService _apiService = ApiService();
  late Future<PenyakitItem?> _detailFuture;

  @override
  void initState() {
    super.initState();
    // Gunakan query parameter yang benar
    _detailFuture = _apiService.getPenyakitById(widget.penyakitId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PenyakitItem?>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final penyakit = snapshot.data;
        if (penyakit == null) {
          return const Scaffold(
            body: Center(child: Text('Data tidak ditemukan')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(penyakit.nama),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar
                  if (penyakit.gambar.isNotEmpty)
                    Image.network(
                      penyakit.gambar,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 16),
                  
                  // Judul
                  Text(
                    penyakit.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Organ
                  Text(
                    'Organ: ${penyakit.organNama}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Deskripsi Singkat
                  _buildSection(
                    'Deskripsi',
                    penyakit.deskripsiSingkat,
                  ),
                  
                  // Penyebab Utama
                  _buildSection(
                    'Penyebab Utama',
                    penyakit.penyebabUtama,
                  ),
                  
                  // Gejala
                  _buildSection(
                    'Gejala',
                    penyakit.gejala,
                  ),
                  
                  // Bahaya
                  _buildSection(
                    'Bahaya/Komplikasi',
                    penyakit.bahaya,
                  ),
                  
                  // Cara Mencegah
                  _buildSection(
                    'Cara Mencegah',
                    penyakit.caraMencegah,
                  ),
                  
                  // Cara Mengurangi
                  _buildSection(
                    'Cara Mengurangi Risiko',
                    penyakit.caraMengurangi,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
```

### C. Profil Dokter Screen

Update `lib/profil_dokter.dart`:
```dart
class ProfilDokterContent extends StatefulWidget {
  const ProfilDokterContent({super.key});

  @override
  State<ProfilDokterContent> createState() => _ProfilDokterContentState();
}

class _ProfilDokterContentState extends State<ProfilDokterContent> {
  final ApiService _apiService = ApiService();
  late Future<ProfilDokter> _profilFuture;

  @override
  void initState() {
    super.initState();
    _profilFuture = _apiService.getProfilDokter();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfilDokter>(
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Foto Profil
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profil.fotoProfil.isNotEmpty
                      ? NetworkImage(profil.fotoProfil)
                      : null,
                  child: profil.fotoProfil.isEmpty
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                const SizedBox(height: 16),
                
                // Nama Dokter
                Text(
                  profil.nama,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Spesialisasi
                Text(
                  profil.spesialisasi,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Biodata
                Text(
                  profil.biodata,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                
                // Riwayat Pendidikan
                _buildSection('Riwayat Pendidikan', profil.sertifikat),
                
                // Penghargaan
                _buildSection('Penghargaan', profil.penghargaan),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text('• $item'),
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}
```

### D. Jadwal Praktik Screen

Verify `lib/jadwal_praktek/jadwal_praktek.dart` sudah menggunakan API:
```dart
Future<List<RumahSakitItem>> _loadJadwalPraktek() async {
  final jadwal = await _apiService.getJadwalPraktek();
  setState(() {
    _jadwalPraktek = jadwal;
  });
  return jadwal;
}
```

✅ **Ini sudah bekerja dengan API!**

### E. Pelayanan Screen

Update `lib/pelayanan/pelayanan.dart`:
```dart
Future<List<PelayananItem>> _loadPelayananList() async {
  final pelayanan = await _apiService.getPelayananList();
  setState(() {
    _allPelayanan = pelayanan;
    _filtered = pelayanan;
  });
  return pelayanan;
}
```

---

## 🧪 Step 5: Testing & Debugging

### Debug Network Requests
Tambah logging di `lib/services/api_service.dart`:

```dart
Future<Map<String, dynamic>> _get(String endpoint) async {
  final url = Uri.parse('$baseUrl$endpoint');
  print('API REQUEST: GET $url');
  
  try {
    final response = await (httpClient ?? http.Client())
        .get(url)
        .timeout(ApiConfig.timeoutDuration);

    print('API RESPONSE: ${response.statusCode}');
    print('API BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    return jsonDecode(response.body);
  } catch (e) {
    print('API ERROR: $e');
    rethrow;
  }
}
```

### Run Flutter App
```bash
cd c:\xampp\htdocs\app_dokter
flutter run
```

### Check Android Emulator Connection
```bash
# List AVDs
flutter emulators

# Run specific emulator
flutter emulators --launch <emulator_id>

# Run app
flutter run
```

---

## 📋 API Endpoints Reference

| Endpoint | Response Model | Used In |
|----------|----------------|---------|
| `/organ.php` | `List<OrganItem>` | Kategori Organ Screen |
| `/penyakit.php` | `List<PenyakitItem>` | Kategori Penyakit Screen |
| `/penyakit.php?id=X` | `PenyakitItem` | Detail Penyakit Screen |
| `/penyakit.php?organId=X` | `List<PenyakitItem>` | Kategori Penyakit by Organ |
| `/profil_dokter.php` | `ProfilDokter` | Profil Dokter Screen |
| `/jadwal_praktek.php` | `List<RumahSakitItem>` | Jadwal Praktik Screen |
| `/pelayanan.php` | `List<PelayananItem>` | Pelayanan Screen |

---

## 🔐 Security Notes

1. **API Key**: Tambah jika production:
```dart
static const String apiKey = 'YOUR_API_KEY';

// Di request header:
headers['X-API-Key'] = apiKey;
```

2. **HTTPS**: Production harus gunakan HTTPS

3. **Error Handling**: Jangan expose detail error ke user:
```dart
if (snapshot.hasError) {
  return Center(
    child: Text('Terjadi kesalahan. Silakan coba lagi.'),
  );
}
```

---

## ✅ Checklist

- [ ] Update API config dengan baseUrl yang benar
- [ ] Test API endpoint dengan curl
- [ ] Jalankan flutter app
- [ ] Test semua screen yang consume API
- [ ] Verify data muncul dengan benar
- [ ] Test error handling
- [ ] Test network timeout
- [ ] Deploy ke device/emulator real

---

## 🆘 Troubleshooting

### "Connection refused"
- ✅ Pastikan XAMPP running
- ✅ Verify URL di api_config.dart
- ✅ Check firewall

### "No data displayed"
- ✅ Check database WebDokter ada data
- ✅ Verify field status = 'aktif'
- ✅ Check API response dengan curl

### "CORS error"
- ✅ Verify db.php memiliki CORS headers
- ✅ Reload page/app

### "Timeout error"
- ✅ Naikkan timeout duration
- ✅ Check server performance
- ✅ Check network speed

---

## 📞 Resources

- 📖 [WebDokter API Docs](../../api/README.md)
- 📖 [Mobile Integration Guide](../../api/MOBILE_INTEGRATION_GUIDE.md)
- 🧪 [API Tester](../../api/examples/api_tester.html)
- 📦 [Postman Collection](../../api/WebDokter_API.postman_collection.json)

---

**Version**: 1.0  
**Last Updated**: 2024  
**Status**: ✅ Ready for Integration
