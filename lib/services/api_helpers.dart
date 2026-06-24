// ─────────────────────────────────────────────────────────────────────────────
// APP_DOKTER - API Integration Helpers
// File ini berisi helper functions dan extensions untuk kemudahan integrasi API
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';

// ─── SINGLETON PATTERN FOR API SERVICE ───────────────────────────────────────

/// Global API Service instance (singleton pattern)
/// Gunakan: `final api = apiService;`
final apiService = ApiService();

// ─── MOCK DATA FOR TESTING ──────────────────────────────────────────────────

/// Use mock data when API is offline
/// Set this to true untuk testing tanpa API
const bool USE_MOCK_DATA = false;

class MockDataProvider {
  static List<Map<String, dynamic>> mockOrgans = [
    {
      'id': 1,
      'nama': 'Jantung',
      'deskripsi': 'Organ pemompa darah',
      'icon': '❤️',
      'warna': '#FF0000',
    },
    {
      'id': 2,
      'nama': 'Paru-paru',
      'deskripsi': 'Organ pernapasan',
      'icon': '🫁',
      'warna': '#FF69B4',
    },
  ];

  static List<Map<String, dynamic>> mockDiseases = [
    {
      'id': 1,
      'nama': 'Hipertensi',
      'organ_nama': 'Jantung',
      'deskripsi_singkat': 'Tekanan darah tinggi',
      'gambar': '',
      'penyebab_utama': 'Gaya hidup tidak sehat',
      'gejala': 'Sakit kepala, pusing',
      'bahaya': 'Stroke, serangan jantung',
      'cara_mencegah': 'Olahraga teratur',
      'cara_mengurangi': 'Kurangi garam',
    },
  ];
}

// ─── RETRY LOGIC ────────────────────────────────────────────────────────────

/// Retry function dengan exponential backoff
Future<T> retryWithBackoff<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
  Duration initialDelay = const Duration(seconds: 1),
}) async {
  int attempt = 0;
  Duration delay = initialDelay;

  while (true) {
    try {
      return await operation();
    } catch (e) {
      attempt++;
      if (attempt >= maxRetries) {
        rethrow;
      }

      if (kDebugMode) {
        print('Retry attempt $attempt after ${delay.inSeconds}s...');
      }

      await Future.delayed(delay);
      delay *= 2; // Exponential backoff
    }
  }
}

// ─── CACHING HELPER ─────────────────────────────────────────────────────────

class CacheManager {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, DateTime> _cacheTime = {};
  static const Duration defaultCacheDuration = Duration(minutes: 5);

  static void set(String key, dynamic value) {
    _cache[key] = value;
    _cacheTime[key] = DateTime.now();
  }

  static dynamic get(String key, [Duration duration = defaultCacheDuration]) {
    if (!_cache.containsKey(key)) return null;

    final cacheAge = DateTime.now().difference(_cacheTime[key]!);
    if (cacheAge > duration) {
      _cache.remove(key);
      _cacheTime.remove(key);
      return null;
    }

    return _cache[key];
  }

  static void clear() {
    _cache.clear();
    _cacheTime.clear();
  }

  static void remove(String key) {
    _cache.remove(key);
    _cacheTime.remove(key);
  }
}

// ─── API RESPONSE HELPER ─────────────────────────────────────────────────────

class ApiResponseHelper {
  /// Check if response is successful
  static bool isSuccess(Map<String, dynamic> response) {
    return response['success'] == true;
  }

  /// Get error message from response
  static String getErrorMessage(Map<String, dynamic> response) {
    return response['message'] ?? 'Terjadi kesalahan';
  }

  /// Get data from response
  static dynamic getData(Map<String, dynamic> response) {
    return response['data'];
  }
}

// ─── NETWORK HELPER ─────────────────────────────────────────────────────────

class NetworkHelper {
  static Future<bool> isConnected() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();

    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;
  }

  static Stream<bool> connectionStatus() {
    return Connectivity().onConnectivityChanged.map(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi,
    );
  }
}

// ─── ERROR HANDLER ───────────────────────────────────────────────────────────

class ApiErrorHandler {
  static String handleError(dynamic error) {
    if (error is TimeoutException) {
      return 'Koneksi timeout. Silakan coba lagi.';
    } else if (error is SocketException) {
      return 'Tidak dapat terhubung ke server.';
    } else if (error is FormatException) {
      return 'Format data tidak valid.';
    } else {
      return 'Terjadi kesalahan: $error';
    }
  }
}

// ─── FUTURE BUILDER HELPER ──────────────────────────────────────────────────

class ApiBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext, T) builder;
  final Widget Function(BuildContext, Object)? errorBuilder;
  final Widget Function(BuildContext)? loadingBuilder;

  const ApiBuilder({
    required this.future,
    required this.builder,
    this.errorBuilder,
    this.loadingBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder?.call(context) ??
              const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error!) ??
              Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('Tidak ada data'));
        }

        return builder(context, snapshot.data as T);
      },
    );
  }
}

// ─── EXTENSIONS ──────────────────────────────────────────────────────────────

extension StringExtension on String {
  /// Check if string is a valid URL
  bool isValidUrl() {
    try {
      Uri.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Safe network image with fallback
  String toNetworkImageUrl({
    String fallback = 'https://placehold.co/120x90?text=No+Image',
  }) {
    if (isEmpty || !isValidUrl()) {
      return fallback;
    }
    return this;
  }
}

extension ListExtension<T> on List<T> {
  /// Get first element or null
  T? getFirstOrNull() {
    return isEmpty ? null : first;
  }

  /// Filter and map in one operation
  List<R> filterMap<R>(R? Function(T) transform) {
    return map((item) {
      final result = transform(item);
      return result;
    }).whereType<R>().toList();
  }
}

// ─── DEBUGGING HELPER ────────────────────────────────────────────────────────

class DebugHelper {
  static void logApiCall(String endpoint, [String? params]) {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📡 API CALL: $endpoint');
      if (params != null) print('📝 PARAMS: $params');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }

  static void logApiResponse(String endpoint, dynamic response) {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('✅ API RESPONSE: $endpoint');
      print('📦 DATA: $response');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }

  static void logError(String endpoint, dynamic error) {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('❌ API ERROR: $endpoint');
      print('🚨 ERROR: $error');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }
}

// ─── USAGE EXAMPLES ──────────────────────────────────────────────────────────

/*

// EXAMPLE 1: Simple usage with singleton
import 'api_helpers.dart';

Future<void> loadOrgans() async {
  try {
    final organs = await apiService.getOrganList();
    print(organs);
  } catch (e) {
    print('Error: $e');
  }
}

// EXAMPLE 2: With retry logic
Future<void> loadOrgansWithRetry() async {
  try {
    final organs = await retryWithBackoff(
      () => apiService.getOrganList(),
      maxRetries: 3,
    );
    print(organs);
  } catch (e) {
    print('Error after retries: $e');
  }
}

// EXAMPLE 3: With caching
Future<void> loadOrgansWithCache() async {
  // Check cache first
  final cached = CacheManager.get('organs');
  if (cached != null) {
    print('Using cached data: $cached');
    return;
  }

  // If not in cache, fetch from API
  try {
    final organs = await apiService.getOrganList();
    CacheManager.set('organs', organs); // Cache it
    print(organs);
  } catch (e) {
    print('Error: $e');
  }
}

// EXAMPLE 4: In FutureBuilder
FutureBuilder(
  future: apiService.getOrganList(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(snapshot.data![index].nama),
          );
        },
      );
    }
    return const CircularProgressIndicator();
  },
)

// EXAMPLE 5: Using ApiBuilder widget
ApiBuilder(
  future: apiService.getOrganList(),
  builder: (context, organs) => ListView.builder(
    itemCount: organs.length,
    itemBuilder: (context, index) => ListTile(
      title: Text(organs[index].nama),
    ),
  ),
  loadingBuilder: (context) => const Center(
    child: CircularProgressIndicator(),
  ),
  errorBuilder: (context, error) => Center(
    child: Text('Error: $error'),
  ),
)

*/
