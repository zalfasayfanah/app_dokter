# Setup API Integration untuk Flutter App Dokter

Dokumentasi ini menjelaskan cara mengintegrasikan Flutter App Dokter dengan backend website Anda.

## 📋 Daftar Isi
1. [Prasyarat](#prasyarat)
2. [Struktur API](#struktur-api)
3. [Konfigurasi](#konfigurasi)
4. [Endpoint API](#endpoint-api)
5. [Contoh Response](#contoh-response)
6. [Testing API](#testing-api)
7. [Troubleshooting](#troubleshooting)

---

## Prasyarat

- Backend server berjalan (Laravel, Node.js, PHP, dll)
- Server dapat diakses dari aplikasi Flutter
- Database sudah terisi dengan data

---

## Struktur API

Struktur folder untuk API:

```
lib/
├── config/
│   └── api_config.dart          # Konfigurasi URL dan endpoints
├── models/
│   └── api_models.dart          # Data models dari API
└── services/
    └── api_service.dart         # Service untuk HTTP requests
```

---

## Konfigurasi

### 1. Update Base URL

Edit file `lib/config/api_config.dart` dan sesuaikan `baseUrl`:

```dart
class EnvironmentConfig {
  static const Environment currentEnvironment = Environment.development;

  static String getBaseUrl() {
    switch (currentEnvironment) {
      case Environment.development:
        return 'http://localhost:8000'; // atau http://192.168.1.100:8000
      case Environment.staging:
        return 'https://staging.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }
}
```

### 2. Ganti Environment (Jika Perlu)

```dart
static const Environment currentEnvironment = Environment.production;
```

---

## Endpoint API

Backend Anda harus menyediakan endpoint berikut dengan format response JSON:

### 1. **GET /api/jadwal-praktek** - Jadwal Praktik
Mendapatkan list semua jadwal praktik di rumah sakit.

**Query Parameters (Opsional):**
- `page` - Nomor halaman (untuk pagination)
- `limit` - Jumlah data per halaman

**Response Success (200):**
```json
{
  "success": true,
  "message": "Data jadwal praktik berhasil diambil",
  "data": [
    {
      "id": "1",
      "nama": "RS UNIMUS",
      "alamat": "Jl. Kedungmundu No.214",
      "imageUrl": "https://example.com/image.jpg",
      "jadwal": [
        {
          "hari": "Senin",
          "jam": "08.00 - 12.00"
        },
        {
          "hari": "Selasa",
          "jam": "08.00 - 12.00"
        }
      ]
    }
  ]
}
```

---

### 2. **GET /api/jadwal-praktek/:id** - Detail Jadwal Praktik
Mendapatkan detail jadwal praktik berdasarkan ID.

**Response Success (200):**
```json
{
  "success": true,
  "message": "Detail jadwal praktik berhasil diambil",
  "data": {
    "id": "1",
    "nama": "RS UNIMUS",
    "alamat": "Jl. Kedungmundu No.214",
    "imageUrl": "https://example.com/image.jpg",
    "jadwal": [
      {
        "hari": "Senin",
        "jam": "08.00 - 12.00"
      }
    ]
  }
}
```

---

### 3. **GET /api/profil-dokter** - Profil Dokter
Mendapatkan profil dokter.

**Response Success (200):**
```json
{
  "success": true,
  "message": "Profil dokter berhasil diambil",
  "data": {
    "id": "1",
    "nama": "Dr. Arif Rahman, Sp.PD",
    "spesialisasi": "Spesialis Penyakit Dalam & Terapi Regeneratif",
    "pengalaman": "10+ Tahun",
    "biodata": "Dokter berpengalaman dengan sertifikasi internasional...",
    "fotoProfil": "https://example.com/foto.jpg",
    "sertifikat": [
      "FINASIM",
      "FINEM",
      "AIFO-K",
      "FISQua"
    ],
    "penghargaan": [
      "Penghargaan Dokter Terbaik 2023"
    ]
  }
}
```

---

### 4. **GET /api/organ** - List Organ
Mendapatkan list semua kategori organ.

**Response Success (200):**
```json
{
  "success": true,
  "message": "List organ berhasil diambil",
  "data": [
    {
      "id": "1",
      "nama": "Jantung",
      "deskripsi": "Masalah Jantung, Pembuluh Darah dan Sirkulasi",
      "iconName": "favorite",
      "gambar": "https://example.com/jantung.jpg"
    },
    {
      "id": "2",
      "nama": "Paru-Paru",
      "deskripsi": "Masalah Paru-paru dan Saluran Pernafasan",
      "iconName": "air",
      "gambar": "https://example.com/paru.jpg"
    }
  ]
}
```

---

### 5. **GET /api/penyakit** - List Penyakit
Mendapatkan list semua penyakit atau filter berdasarkan organ.

**Query Parameters:**
- `organId` - Filter penyakit berdasarkan ID organ

**Response Success (200):**
```json
{
  "success": true,
  "message": "List penyakit berhasil diambil",
  "data": [
    {
      "id": "1",
      "nama": "Hipertensi",
      "deskripsi": "Tekanan darah tinggi",
      "gejala": "Sakit kepala, pusing, dada terasa tegang",
      "penyebab": "Stress, diet tinggi garam, kegemukan",
      "penanganan": "Konsumsi obat, olahraga teratur, diet sehat",
      "organId": "1"
    }
  ]
}
```

---

### 6. **GET /api/penyakit/:id** - Detail Penyakit
Mendapatkan detail penyakit berdasarkan ID.

**Response Success (200):**
```json
{
  "success": true,
  "message": "Detail penyakit berhasil diambil",
  "data": {
    "id": "1",
    "nama": "Hipertensi",
    "deskripsi": "Tekanan darah tinggi",
    "gejala": "Sakit kepala, pusing, dada terasa tegang",
    "penyebab": "Stress, diet tinggi garam, kegemukan",
    "penanganan": "Konsumsi obat, olahraga teratur, diet sehat",
    "organId": "1"
  }
}
```

---

### 7. **GET /api/pelayanan** - List Pelayanan
Mendapatkan list semua pelayanan.

**Response Success (200):**
```json
{
  "success": true,
  "message": "List pelayanan berhasil diambil",
  "data": [
    {
      "id": "1",
      "nama": "Konsultasi Online",
      "deskripsi": "Berkonsultasi dengan dokter melalui video call",
      "icon": "videocam",
      "gambar": "https://example.com/konsultasi.jpg",
      "harga": 250000
    },
    {
      "id": "2",
      "nama": "Pemeriksaan Fisik",
      "deskripsi": "Pemeriksaan fisik langsung di klinik",
      "icon": "medical_services",
      "gambar": "https://example.com/pemeriksaan.jpg",
      "harga": 500000
    }
  ]
}
```

---

## Contoh Response Error

Ketika terjadi error, response harus mengikuti format:

**400 Bad Request:**
```json
{
  "success": false,
  "message": "Data tidak valid"
}
```

**401 Unauthorized:**
```json
{
  "success": false,
  "message": "Token tidak valid"
}
```

**404 Not Found:**
```json
{
  "success": false,
  "message": "Data tidak ditemukan"
}
```

**500 Server Error:**
```json
{
  "success": false,
  "message": "Terjadi kesalahan pada server"
}
```

---

## Testing API

### Menggunakan Postman

1. Buka Postman
2. Buat request baru dengan method GET
3. URL: `http://localhost:8000/api/jadwal-praktek`
4. Klik Send

Atau bisa menggunakan command line:

```bash
# GET request
curl -X GET http://localhost:8000/api/jadwal-praktek

# Dengan header
curl -X GET http://localhost:8000/api/jadwal-praktek \
  -H "Content-Type: application/json"
```

---

## Menggunakan API di Flutter

### Contoh: Fetch Jadwal Praktik

```dart
import 'package:app_dokter/services/api_service.dart';
import 'package:app_dokter/models/api_models.dart';

// Dalam widget
final apiService = ApiService();

try {
  final jadwal = await apiService.getJadwalPraktek();
  print('Jadwal: $jadwal');
} catch (e) {
  print('Error: $e');
}
```

### Contoh: Fetch dengan FutureBuilder (Sudah Diterapkan)

```dart
FutureBuilder<List<RumahSakitItem>>(
  future: apiService.getJadwalPraktek(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    final data = snapshot.data ?? [];
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Text(data[index].nama);
      },
    );
  },
)
```

---

## Troubleshooting

### 1. Connection Refused (Connection Refused)

**Gejala:**
```
Connection refused: Unable to connect to 127.0.0.1:8000
```

**Solusi:**
- Pastikan server backend sedang berjalan
- Jika menggunakan emulator Android, ganti `localhost` dengan `10.0.2.2`
- Cek URL di `lib/config/api_config.dart`

```dart
// Untuk emulator Android
return 'http://10.0.2.2:8000';

// Untuk device fisik / iOS simulator
return 'http://localhost:8000';
```

---

### 2. SSL Certificate Error

**Gejala:**
```
CERTIFICATE_VERIFY_FAILED
```

**Solusi (Untuk Development Saja):**
```dart
import 'package:http/http.dart' as http;

class ApiService {
  // Disable SSL verification (JANGAN gunakan di production!)
  static final HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
}
```

---

### 3. CORS Error

**Gejala:**
```
CORS policy: No 'Access-Control-Allow-Origin' header
```

**Solusi (Backend):**
Setup CORS di backend Anda:

**Laravel:**
```php
// config/cors.php
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

**Node.js/Express:**
```javascript
const cors = require('cors');
app.use(cors());
```

---

### 4. Response Format Tidak Sesuai

**Gejala:**
```
Unexpected character
```

**Solusi:**
Pastikan API mengembalikan JSON yang valid:

```json
{
  "success": true,
  "message": "OK",
  "data": []
}
```

Gunakan JSON validator di https://jsonlint.com/

---

## Tips & Best Practices

1. **Selalu Handle Error**
   - Gunakan try-catch
   - Tampilkan pesan error yang user-friendly

2. **Gunakan Loading State**
   - Tampilkan loading indicator saat fetch data
   - Cegah user berinteraksi sebelum data selesai diload

3. **Cache Data (Opsional)**
   - Simpan data ke local storage untuk offline support
   - Gunakan package seperti `shared_preferences` atau `hive`

4. **Timeout Request**
   - Default timeout sudah di-set ke 30 detik
   - Sesuaikan jika perlu

5. **Logging**
   - Selalu log request dan response untuk debugging
   - Gunakan package `logger` untuk logging yang lebih baik

---

## Support

Jika ada pertanyaan atau masalah, silakan buat issue di repository atau hubungi tim support.

---

**Last Updated:** June 2, 2026
