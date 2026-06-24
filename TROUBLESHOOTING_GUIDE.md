# ✅ APP_DOKTER - Integration Checklist & Troubleshooting

## 🚀 Pre-Integration Checklist

### Backend Setup
- [ ] XAMPP running (Apache + MySQL)
- [ ] WebDokter database sudah created
- [ ] Database sudah filled dengan data
- [ ] API endpoints sudah tested di browser
- [ ] CORS headers sudah enabled di `api/db.php`

### Flutter Project Setup
- [ ] Flutter SDK installed
- [ ] Android Studio / Xcode installed
- [ ] Emulator / Device available
- [ ] All dependencies installed (`flutter pub get`)

### Network Configuration
- [ ] Know the IP address of development machine
- [ ] Know which port XAMPP running on (usually 80)
- [ ] Firewall allows HTTP traffic

---

## 🔧 Integration Steps

### Step 1: Update API Configuration
```dart
// File: lib/config/api_config.dart

// Change this line:
static const String baseUrl = 'http://localhost/WebDokter/api';

// For Android Emulator use: http://10.0.2.2/WebDokter/api
// For iOS Simulator use: http://localhost/WebDokter/api
// For Real Device use: http://<YOUR_COMPUTER_IP>/WebDokter/api
```

**How to find your computer IP:**
```bash
# Windows
ipconfig

# Mac/Linux
ifconfig
```

### Step 2: Install Dependencies (if needed)
```bash
cd c:\xampp\htdocs\app_dokter
flutter pub get
```

### Step 3: Verify Models Match API Response
Check `lib/models/api_models.dart` has these models:
- [ ] `OrganItem` - untuk organ data
- [ ] `PenyakitItem` - untuk disease data
- [ ] `ProfilDokter` - untuk doctor profile
- [ ] `RumahSakitItem` - untuk jadwal praktik
- [ ] `PelayananItem` - untuk services

### Step 4: Update Screens to Use API
- [ ] `kategori_organ.dart` - uses `getOrganList()`
- [ ] `kategori_penyakit.dart` - uses `getPenyakitByOrganId()`
- [ ] `detail_penyakit.dart` - uses `getPenyakitById()`
- [ ] `profil_dokter.dart` - uses `getProfilDokter()`
- [ ] `jadwal_praktek.dart` - uses `getJadwalPraktek()`
- [ ] `pelayanan.dart` - uses `getPelayananList()`

### Step 5: Test in Emulator
```bash
flutter run
```

---

## 🧪 Testing Procedures

### Test 1: Verify API is Running
```bash
# Windows PowerShell
curl http://localhost/WebDokter/api

# Should return JSON with endpoints list
```

### Test 2: Verify Database Connection
```bash
# Test organ endpoint
curl http://localhost/WebDokter/api/organ.php

# Should return:
# {"success": true, "message": "...", "data": [...]}
```

### Test 3: Test in Flutter App
```bash
# Start emulator
flutter emulators --launch <emulator_id>

# Run app
flutter run -v

# Check console for API calls and responses
```

### Test 4: Check Individual Endpoints

#### Organs
```bash
curl http://localhost/WebDokter/api/organ.php
```

#### Diseases
```bash
# All diseases
curl http://localhost/WebDokter/api/penyakit.php

# Diseases by organ (id=1)
curl "http://localhost/WebDokter/api/penyakit.php?organId=1"

# Disease detail (id=1)
curl "http://localhost/WebDokter/api/penyakit.php?id=1"
```

#### Doctor Profile
```bash
curl http://localhost/WebDokter/api/profil_dokter.php
```

#### Schedules
```bash
curl http://localhost/WebDokter/api/jadwal_praktek.php
```

#### Services
```bash
curl http://localhost/WebDokter/api/pelayanan.php
```

---

## 🐛 Troubleshooting Guide

### Problem 1: "Connection refused" Error

**Symptoms:**
```
Error: Connection refused
Socket Exception: Connection refused
```

**Causes:**
1. XAMPP not running
2. Wrong base URL
3. Port not open
4. Firewall blocking

**Solutions:**
```bash
# Check if XAMPP is running
# Windows: Open XAMPP Control Panel, click Start Apache

# Check if server is accessible
curl http://localhost/WebDokter/api

# If using different computer:
# Find your IP: ipconfig
# Update baseUrl: http://<YOUR_IP>/WebDokter/api

# Check firewall
# Windows: Settings > Firewall > Allow apps > Allow Apache
```

### Problem 2: Empty Data Response

**Symptoms:**
```
API returns: {"success": true, "data": []}
```

**Causes:**
1. No data in database
2. Data status not 'aktif'
3. Wrong table name

**Solutions:**
```bash
# Open phpMyAdmin
# http://localhost/phpmyadmin

# Check if data exists in tables:
# SELECT * FROM kategori_organ;
# SELECT * FROM penyakit;

# Check status field:
# SELECT * FROM kategori_organ WHERE status = 'aktif';
```

### Problem 3: CORS Error

**Symptoms:**
```
Access to XMLHttpRequest at 'http://localhost/WebDokter/api/organ.php' 
from origin 'http://localhost:8000' has been blocked by CORS policy
```

**Causes:**
1. CORS headers missing in API
2. Wrong origin in CORS config

**Solutions:**
```php
// File: api/db.php
// Add/verify these headers:

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
```

### Problem 4: JSON Decode Error

**Symptoms:**
```
FormatException: Unexpected character
Expected: valid JSON
```

**Causes:**
1. API returning HTML instead of JSON (PHP error)
2. API returning non-JSON content
3. Character encoding issue

**Solutions:**
```bash
# Check raw API response
curl -v http://localhost/WebDokter/api/organ.php

# Should see:
# Content-Type: application/json
# {"success": true, ...}

# If seeing HTML, check for PHP errors:
# Look for PHP error in response
# Fix the error in api/db.php or endpoint file
```

### Problem 5: Model Mapping Error

**Symptoms:**
```
NoSuchMethodError: The method 'fromJson' was called on null.
type '_Map<String, dynamic>' is not a subtype of type...
```

**Causes:**
1. API response format doesn't match model
2. Missing fields in model fromJson
3. Wrong field names

**Solutions:**
```dart
// Update model to match API response
// Example: If API returns 'organ_nama', model must use that name

factory PenyakitItem.fromJson(Map<String, dynamic> json) {
  return PenyakitItem(
    id: json['id']?.toString() ?? '', // Add toString() for safety
    nama: json['nama'] ?? '',
    organNama: json['organ_nama'] ?? '', // Use exact API field name
    // ... other fields
  );
}

// Use safe navigation:
final value = json['field_name'] ?? 'default_value';
```

### Problem 6: Timeout Error

**Symptoms:**
```
TimeoutException: Future not completed after 30 seconds
```

**Causes:**
1. Server is slow
2. API endpoint has error (infinite loop)
3. Network is slow
4. Request getting blocked

**Solutions:**
```dart
// Increase timeout in api_config.dart
static const Duration timeoutDuration = Duration(seconds: 60);

// Or use retry logic:
import 'services/api_helpers.dart';

final organs = await retryWithBackoff(
  () => apiService.getOrganList(),
  maxRetries: 3,
);
```

### Problem 7: 404 Not Found Error

**Symptoms:**
```
HTTP 404: Not Found
```

**Causes:**
1. Wrong endpoint path
2. File doesn't exist
3. Typo in filename

**Solutions:**
```bash
# Verify file exists
# Check: c:\xampp\htdocs\WebDokter\api\organ.php

# Test each endpoint:
curl http://localhost/WebDokter/api/organ.php         # Should work
curl http://localhost/WebDokter/api/penyakit.php      # Should work
curl http://localhost/WebDokter/api/profil_dokter.php # Should work

# Verify baseUrl doesn't have trailing slash
# WRONG: http://localhost/WebDokter/api/
# CORRECT: http://localhost/WebDokter/api
```

### Problem 8: Database Connection Error

**Symptoms:**
```
PDOException: SQLSTATE[HY000]: General error: ...
Tidak dapat terhubung ke database
```

**Causes:**
1. MySQL not running
2. Wrong credentials
3. Database doesn't exist

**Solutions:**
```bash
# Check MySQL running
# Windows: Open XAMPP, click Start MySQL

# Verify credentials in config/Koneksi.php:
# - host: localhost
# - db_name: webdokter
# - user: root
# - password: (empty for default XAMPP)

# Test connection in phpMyAdmin
# http://localhost/phpmyadmin
```

### Problem 9: Different IP Address Issues

**Symptoms:**
```
Cannot connect when using phone on same network
```

**Causes:**
1. Using localhost instead of IP address
2. Firewall blocking
3. Wrong IP address

**Solutions:**
```dart
// Get your computer IP:
// Windows: ipconfig (look for IPv4 Address, e.g., 192.168.x.x)

// Update in lib/config/api_config.dart:
static const String baseUrl = 'http://192.168.x.x/WebDokter/api';

// Test with curl from same network:
curl http://192.168.x.x/WebDokter/api/organ.php

// Check firewall:
// Windows Firewall > Allow app > Allow Apache
```

### Problem 10: SSL Certificate Error (Production)

**Symptoms:**
```
certificate verify failed
SSL: CERTIFICATE_VERIFY_FAILED
```

**Causes:**
1. Using self-signed certificate
2. Invalid SSL certificate

**Solutions:**
```dart
// Temporary: Disable SSL verification (NOT for production!)
import 'package:http/http.dart' as http;

class BadCertificateClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final client = http.Client();
    return client.send(request).then((response) => response);
  }
}

// Better: Get valid SSL certificate from Let's Encrypt
```

---

## 📋 Testing Matrix

| Component | Status | Notes |
|-----------|--------|-------|
| XAMPP Apache | ✅/❌ | Check Control Panel |
| XAMPP MySQL | ✅/❌ | Check Control Panel |
| WebDokter Database | ✅/❌ | Check phpMyAdmin |
| API Gateway | ✅/❌ | curl http://localhost/WebDokter/api |
| /organ.php | ✅/❌ | curl .../organ.php |
| /penyakit.php | ✅/❌ | curl .../penyakit.php |
| /profil_dokter.php | ✅/❌ | curl .../profil_dokter.php |
| /jadwal_praktek.php | ✅/❌ | curl .../jadwal_praktek.php |
| /pelayanan.php | ✅/❌ | curl .../pelayanan.php |
| Flutter App | ✅/❌ | flutter run |
| Network Connectivity | ✅/❌ | ping localhost |

---

## 🎯 Quick Fixes

### All endpoints returning empty data
```bash
# Check database has data
# Open phpMyAdmin: http://localhost/phpmyadmin
# Check kategori_organ, penyakit tables
# Make sure status = 'aktif'
```

### App crashes on startup
```bash
# Check pubspec.lock is up to date
flutter pub get

# Run with verbose mode to see full error
flutter run -v
```

### API returns different data than expected
```bash
# Test API directly to see actual response
curl -H "Content-Type: application/json" http://localhost/WebDokter/api/organ.php

# Compare with model fromJson implementation
# Update model if needed to match API response format
```

---

## 💡 Pro Tips

1. **Use Postman** for testing API before integrating in Flutter
2. **Enable debug logging** to see all API requests/responses
3. **Use mock data** for testing UI before API is ready
4. **Test offline** scenarios with error handling
5. **Cache API responses** to reduce server load
6. **Use Flutter DevTools** for performance monitoring

---

## 📞 Quick Contact

If you get stuck:
1. Check [APP_DOKTER_API_INTEGRATION.md](./APP_DOKTER_API_INTEGRATION.md)
2. Review [WebDokter API Documentation](../WebDokter/api/README.md)
3. Test endpoints in [API Tester](../WebDokter/api/examples/api_tester.html)
4. Import [Postman Collection](../WebDokter/api/WebDokter_API.postman_collection.json)

---

**Last Updated**: 2024
**Version**: 1.0
