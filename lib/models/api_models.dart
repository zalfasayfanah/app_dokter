import 'package:intl/intl.dart';

// ─── Models untuk API Response ───────────────────────────────────────────────

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      statusCode: json['statusCode'],
    );
  }
}

// ─── JADWAL PRAKTIK MODELS ──────────────────────────────────────────────────

class JadwalItem {
  final String hari;
  final String jam;

  const JadwalItem({required this.hari, required this.jam});

  factory JadwalItem.fromJson(Map<String, dynamic> json) {
    return JadwalItem(hari: json['hari'] ?? '', jam: json['jam'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'hari': hari, 'jam': jam};
  }
}

class RumahSakitItem {
  final String id;
  final String nama;
  final String alamat;
  final String imageUrl;
  final List<JadwalItem> jadwal;

  const RumahSakitItem({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.imageUrl,
    required this.jadwal,
  });

  factory RumahSakitItem.fromJson(Map<String, dynamic> json) {
    return RumahSakitItem(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      imageUrl:
          json['imageUrl'] ??
          'https://placehold.co/120x90/2ecc71/ffffff?text=RS',
      jadwal:
          (json['jadwal'] as List<dynamic>?)
              ?.map((j) => JadwalItem.fromJson(j))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'imageUrl': imageUrl,
      'jadwal': jadwal.map((j) => j.toJson()).toList(),
    };
  }
}

// ─── PROFIL DOKTER MODELS ──────────────────────────────────────────────────

class ProfilDokter {
  final String id;
  final String nama;
  final String spesialisasi;
  final String pengalaman;
  final String biodata;
  final String fotoProfil;
  final List<String> sertifikat;
  final List<String> penghargaan;

  const ProfilDokter({
    required this.id,
    required this.nama,
    required this.spesialisasi,
    required this.pengalaman,
    required this.biodata,
    required this.fotoProfil,
    required this.sertifikat,
    required this.penghargaan,
  });

  factory ProfilDokter.fromJson(Map<String, dynamic> json) {
    return ProfilDokter(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? 'Dr. Arif Rahman, Sp.PD',
      spesialisasi: json['spesialisasi'] ?? 'Spesialis Penyakit Dalam',
      pengalaman: json['pengalaman'] ?? '10+ Tahun',
      biodata: json['biodata'] ?? '',
      fotoProfil: json['fotoProfil'] ?? 'assets/images/dokter.png',
      sertifikat: List<String>.from(json['sertifikat'] ?? []),
      penghargaan: List<String>.from(json['penghargaan'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'spesialisasi': spesialisasi,
      'pengalaman': pengalaman,
      'biodata': biodata,
      'fotoProfil': fotoProfil,
      'sertifikat': sertifikat,
      'penghargaan': penghargaan,
    };
  }
}

// ─── KATEGORI ORGAN MODELS ─────────────────────────────────────────────────

class OrganItem {
  final String id;
  final String nama;
  final String deskripsi;
  final String iconName;
  final String gambar;

  const OrganItem({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.iconName,
    required this.gambar,
  });

  factory OrganItem.fromJson(Map<String, dynamic> json) {
    return OrganItem(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      iconName: json['iconName'] ?? 'heart',
      gambar: json['gambar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'iconName': iconName,
      'gambar': gambar,
    };
  }
}

// ─── PENYAKIT MODELS ────────────────────────────────────────────────────────

class PenyakitItem {
  final String id;
  final String nama;
  final String deskripsi;
  final String gejala;
  final String penyebab;
  final String penanganan;
  final String organId;

  const PenyakitItem({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.gejala,
    required this.penyebab,
    required this.penanganan,
    required this.organId,
  });

  factory PenyakitItem.fromJson(Map<String, dynamic> json) {
    return PenyakitItem(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gejala: json['gejala'] ?? '',
      penyebab: json['penyebab'] ?? '',
      penanganan: json['penanganan'] ?? '',
      organId: json['organId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'gejala': gejala,
      'penyebab': penyebab,
      'penanganan': penanganan,
      'organId': organId,
    };
  }
}

// ─── PELAYANAN MODELS ──────────────────────────────────────────────────────

class PelayananItem {
  final String id;
  final String nama;
  final String deskripsi;
  final String icon;
  final String gambar;
  final double harga;

  const PelayananItem({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.icon,
    required this.gambar,
    required this.harga,
  });

  factory PelayananItem.fromJson(Map<String, dynamic> json) {
    return PelayananItem(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      icon: json['icon'] ?? 'favorite',
      gambar: json['gambar'] ?? '',
      harga: (json['harga'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'icon': icon,
      'gambar': gambar,
      'harga': harga,
    };
  }
}
