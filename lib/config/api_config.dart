import 'package:flutter/foundation.dart';

// ─── API CONFIGURATION ──────────────────────────────────────────────────────

class ApiConfig {
  // Ganti dengan URL website Anda jika backend berada di host/port lain.
  static const String baseUrl = 'http://10.62.53.123/WebDokter/api';

  // Endpoints untuk PHP native
  static const String jadwalPraktekEndpoint = '/jadwal_praktek.php';
  static const String profilDokterEndpoint = '/profil_dokter.php';
  static const String organEndpoint = '/organ.php';
  static const String penyakitEndpoint = '/penyakit.php';
  static const String pelayananEndpoint = '/pelayanan.php';

  // Timeout Duration
  static const Duration timeoutDuration = Duration(seconds: 30);

  // API Methods
  static const String methodGet = 'GET';
  static const String methodPost = 'POST';
  static const String methodPut = 'PUT';
  static const String methodDelete = 'DELETE';
}

// ─── ENVIRONMENT CONFIGURATION ───────────────────────────────────────────────

enum Environment { development, staging, production }

class EnvironmentConfig {
  static const Environment currentEnvironment = Environment.development;

  static String getBaseUrl() {
    if (kIsWeb) {
      final origin = Uri.base.origin;
      return '$origin/WebDokter/api';
    }

    switch (currentEnvironment) {
      case Environment.development:
        // Gunakan alamat IP host lokal atau alamat emulator Android (10.0.2.2)
        return ApiConfig.baseUrl;
      case Environment.staging:
        return 'https://staging.example.com/WebDokter/api';
      case Environment.production:
        return 'https://api.example.com/WebDokter/api';
    }
  }
}
