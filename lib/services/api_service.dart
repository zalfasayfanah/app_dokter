import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/api_models.dart';

// ─── API SERVICE ────────────────────────────────────────────────────────────

class ApiService {
  static const String _tag = 'ApiService';
  final String baseUrl;
  final http.Client? httpClient;

  ApiService({String? baseUrl, this.httpClient})
    : baseUrl = baseUrl ?? EnvironmentConfig.getBaseUrl();

  // ─── JADWAL PRAKTIK ─────────────────────────────────────────────────────

  /// Fetch jadwal praktik dari API
  /// Returns: List<RumahSakitItem>
  Future<List<RumahSakitItem>> getJadwalPraktek() async {
    try {
      final response = await _get(ApiConfig.jadwalPraktekEndpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((item) => RumahSakitItem.fromJson(item)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load jadwal praktik');
      }
    } catch (e) {
      print('$_tag - Error getting jadwal praktik: $e');
      rethrow;
    }
  }

  /// Fetch jadwal praktik berdasarkan ID rumah sakit
  Future<RumahSakitItem?> getJadwalPraktekById(String id) async {
    try {
      final response = await _get('${ApiConfig.jadwalPraktekEndpoint}/$id');

      if (response['success'] == true && response['data'] != null) {
        return RumahSakitItem.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('$_tag - Error getting jadwal praktik by id: $e');
      rethrow;
    }
  }

  // ─── PROFIL DOKTER ──────────────────────────────────────────────────────

  /// Fetch profil dokter dari API
  Future<ProfilDokter> getProfilDokter() async {
    try {
      final response = await _get(ApiConfig.profilDokterEndpoint);

      if (response['success'] == true && response['data'] != null) {
        return ProfilDokter.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to load profil dokter');
      }
    } catch (e) {
      print('$_tag - Error getting profil dokter: $e');
      rethrow;
    }
  }

  // ─── KATEGORI ORGAN ─────────────────────────────────────────────────────

  /// Fetch list organ dari API
  Future<List<OrganItem>> getOrganList() async {
    try {
      final response = await _get(ApiConfig.organEndpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((item) => OrganItem.fromJson(item)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load organ list');
      }
    } catch (e) {
      print('$_tag - Error getting organ list: $e');
      rethrow;
    }
  }

  // ─── PENYAKIT ───────────────────────────────────────────────────────────

  /// Fetch list penyakit dari API
  Future<List<PenyakitItem>> getPenyakitList() async {
    try {
      final response = await _get(ApiConfig.penyakitEndpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((item) => PenyakitItem.fromJson(item)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load penyakit list');
      }
    } catch (e) {
      print('$_tag - Error getting penyakit list: $e');
      rethrow;
    }
  }

  /// Fetch penyakit berdasarkan organ ID
  Future<List<PenyakitItem>> getPenyakitByOrganId(String organId) async {
    try {
      final response = await _get(
        '${ApiConfig.penyakitEndpoint}?organId=$organId',
      );

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((item) => PenyakitItem.fromJson(item)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load penyakit');
      }
    } catch (e) {
      print('$_tag - Error getting penyakit by organ id: $e');
      rethrow;
    }
  }

  /// Fetch detail penyakit berdasarkan ID
  Future<PenyakitItem?> getPenyakitById(String id) async {
    try {
      final response = await _get('${ApiConfig.penyakitEndpoint}?id=$id');

      if (response['success'] == true && response['data'] != null) {
        return PenyakitItem.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('$_tag - Error getting penyakit by id: $e');
      rethrow;
    }
  }

  // ─── PELAYANAN ──────────────────────────────────────────────────────────

  /// Fetch list pelayanan dari API
  Future<List<PelayananItem>> getPelayananList() async {
    try {
      final response = await _get(ApiConfig.pelayananEndpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((item) => PelayananItem.fromJson(item)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load pelayanan list');
      }
    } catch (e) {
      print('$_tag - Error getting pelayanan list: $e');
      rethrow;
    }
  }

  // ─── PRIVATE HTTP METHODS ──────────────────────────────────────────────

  /// GET request dengan error handling
  Future<Map<String, dynamic>> _get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('$_tag - GET: $url');

      final response = await (httpClient ?? http.Client())
          .get(url)
          .timeout(ApiConfig.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      print('$_tag - GET Error: $e');
      rethrow;
    }
  }

  /// POST request dengan error handling
  Future<Map<String, dynamic>> _post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('$_tag - POST: $url');

      final response = await (httpClient ?? http.Client())
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      print('$_tag - POST Error: $e');
      rethrow;
    }
  }

  /// PUT request dengan error handling
  Future<Map<String, dynamic>> _put(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('$_tag - PUT: $url');

      final response = await (httpClient ?? http.Client())
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      print('$_tag - PUT Error: $e');
      rethrow;
    }
  }

  /// DELETE request dengan error handling
  Future<Map<String, dynamic>> _delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('$_tag - DELETE: $url');

      final response = await (httpClient ?? http.Client())
          .delete(url)
          .timeout(ApiConfig.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      print('$_tag - DELETE Error: $e');
      rethrow;
    }
  }

  /// Handle HTTP response dengan error handling umum
  Map<String, dynamic> _handleResponse(http.Response response) {
    print('$_tag - Status Code: ${response.statusCode}');

    try {
      final jsonResponse = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
        case 201:
          return jsonResponse is Map<String, dynamic>
              ? jsonResponse
              : {'success': true, 'data': jsonResponse};

        case 400:
          throw BadRequestException(jsonResponse['message'] ?? 'Bad Request');

        case 401:
          throw UnauthorizedException(
            jsonResponse['message'] ?? 'Unauthorized',
          );

        case 403:
          throw ForbiddenException(jsonResponse['message'] ?? 'Forbidden');

        case 404:
          throw NotFoundException(jsonResponse['message'] ?? 'Not Found');

        case 500:
          throw ServerException(
            jsonResponse['message'] ?? 'Internal Server Error',
          );

        default:
          throw Exception(
            'Error: ${response.statusCode} - ${jsonResponse['message'] ?? 'Unknown Error'}',
          );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to parse response: $e');
    }
  }
}

// ─── CUSTOM EXCEPTIONS ──────────────────────────────────────────────────────

class BadRequestException implements Exception {
  final String message;

  BadRequestException(this.message);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() => message;
}

class ForbiddenException implements Exception {
  final String message;

  ForbiddenException(this.message);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() => message;
}
