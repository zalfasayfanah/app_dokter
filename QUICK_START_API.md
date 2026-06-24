# Quick Start - API Integration

Panduan cepat untuk menggunakan API yang sudah diintegrasikan ke aplikasi Flutter.

## ⚡ Mulai Cepat

### 1. Update Base URL

Edit `lib/config/api_config.dart`:

```dart
static String getBaseUrl() {
  switch (currentEnvironment) {
    case Environment.development:
      return 'http://localhost:8000'; // ← Ganti dengan URL Anda
    // ...
  }
}
```

### 2. Jalankan Backend API

Backend harus menyediakan endpoint:
- `GET /api/jadwal-praktek`
- `GET /api/profil-dokter`
- `GET /api/organ`
- `GET /api/penyakit`
- `GET /api/pelayanan`

Format response harus sesuai dengan [API_SETUP_GUIDE.md](API_SETUP_GUIDE.md)

### 3. Run Flutter App

```bash
flutter pub get
flutter run
```

## 📁 Struktur Folder API

```
lib/
├── config/
│   └── api_config.dart          # Konfigurasi API
├── models/
│   └── api_models.dart          # Data Models
├── services/
│   └── api_service.dart         # API Service (Core)
├── jadwal_praktek/
│   └── jadwal_praktek.dart      # ✅ Sudah diintegrasikan
├── kesehatan/
│   ├── kategori_organ.dart      # Siap diintegrasikan
│   ├── kategori_penyakit.dart   # Siap diintegrasikan
│   └── detail_penyakit.dart     # Siap diintegrasikan
├── pelayanan/
│   └── pelayanan.dart           # Siap diintegrasikan
└── profil_dokter.dart           # Siap diintegrasikan
```

## ✅ Status Integrasi

| Halaman | Status | File |
|---------|--------|------|
| Jadwal Praktik | ✅ Selesai | jadwal_praktek.dart |
| Profil Dokter | ⏳ Siap | profil_dokter.dart |
| Kategori Organ | ⏳ Siap | kategori_organ.dart |
| Kategori Penyakit | ⏳ Siap | kategori_penyakit.dart |
| Detail Penyakit | ⏳ Siap | detail_penyakit.dart |
| Pelayanan | ⏳ Siap | pelayanan.dart |

## 🚀 API Service Usage

```dart
import 'services/api_service.dart';
import 'models/api_models.dart';

final apiService = ApiService();

// Fetch Jadwal Praktik
final jadwal = await apiService.getJadwalPraktek();

// Fetch Profil Dokter
final profil = await apiService.getProfilDokter();

// Fetch Organ List
final organ = await apiService.getOrganList();

// Fetch Penyakit List
final penyakit = await apiService.getPenyakitList();

// Fetch Penyakit by Organ ID
final penyakitByOrgan = await apiService.getPenyakitByOrganId('1');

// Fetch Penyakit Detail
final detailPenyakit = await apiService.getPenyakitById('1');

// Fetch Pelayanan List
final pelayanan = await apiService.getPelayananList();
```

## 🔧 Konfigurasi

### Development (localhost)
```dart
static String getBaseUrl() {
  // Gunakan IP address jika menggunakan device fisik/emulator
  return 'http://10.0.2.2:8000'; // Emulator Android
  return 'http://localhost:8000'; // iOS Simulator
}
```

### Production
```dart
static const Environment currentEnvironment = Environment.production;

static String getBaseUrl() {
  case Environment.production:
    return 'https://api.example.com';
}
```

## 📚 Dokumentasi

Baca file-file berikut untuk dokumentasi lengkap:

1. **[API_SETUP_GUIDE.md](API_SETUP_GUIDE.md)** - Setup API lengkap & Endpoint
2. **[BACKEND_API_EXAMPLES.md](BACKEND_API_EXAMPLES.md)** - Contoh backend (PHP, Laravel, Node.js, Python)
3. **[INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)** - Cara integrasi ke halaman lain

## ❌ Troubleshooting

### Connection Refused
```
Connection refused: Unable to connect to 127.0.0.1:8000
```
✅ Solusi: Pastikan backend sedang berjalan, check URL di `api_config.dart`

### CORS Error
```
CORS policy: No 'Access-Control-Allow-Origin' header
```
✅ Solusi: Setup CORS di backend (lihat BACKEND_API_EXAMPLES.md)

### Response Format Error
```
Unexpected character
```
✅ Solusi: Response harus berupa valid JSON (gunakan jsonlint.com)

## 📞 Support

Untuk bantuan lebih lanjut:
1. Baca dokumentasi di file-file .md
2. Check contoh response di API_SETUP_GUIDE.md
3. Lihat contoh backend di BACKEND_API_EXAMPLES.md
4. Test API menggunakan Postman

---

**Siap? Mari mulai mengintegrasikan API ke halaman Anda!** 🚀
