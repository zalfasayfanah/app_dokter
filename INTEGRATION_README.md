# 🏥 APP_DOKTER x WebDokter API - Complete Setup Package

Dokumentasi lengkap untuk integrasi APP_DOKTER (Flutter) dengan WebDokter API (PHP).

---

## 📚 Documentation Map

```
├── 📖 README.md
│   └── Overview dan quick start guide
│
├── 🚀 APP_DOKTER_API_INTEGRATION.md ⭐ START HERE
│   └── Complete step-by-step integration guide
│
├── 🐛 TROUBLESHOOTING_GUIDE.md
│   └── Common issues dan solutions
│
└── 📦 Resource Files
    ├── lib/services/api_helpers.dart
    │   └── Helper functions dan utilities
    │
    ├── lib/config/api_config.dart
    │   └── API configuration (EDIT THIS!)
    │
    └── lib/services/api_service.dart
        └── API client implementation
```

---

## ⚡ Quick Start (5 Minutes)

### 1. Update API Config
Edit `lib/config/api_config.dart`:
```dart
static const String baseUrl = 'http://localhost/WebDokter/api';
```

### 2. Verify Backend
```bash
curl http://localhost/WebDokter/api/organ.php
```

### 3. Run App
```bash
flutter run
```

### 4. Check Console
Look for successful API calls in logs.

**✅ Done! Your app is now connected to the WebDokter API!**

---

## 🗂️ Project Structure

```
APP_DOKTER/
├── lib/
│   ├── main.dart                              # Entry point
│   │
│   ├── config/
│   │   └── api_config.dart                   # ⚙️ API CONFIGURATION (EDIT THIS)
│   │
│   ├── services/
│   │   ├── api_service.dart                  # API client
│   │   └── api_helpers.dart                  # ✨ NEW: Helper utilities
│   │
│   ├── models/
│   │   └── api_models.dart                   # Data models
│   │
│   ├── bottom_nav.dart                       # Bottom navigation
│   ├── profil_dokter.dart                    # Doctor profile screen
│   ├── splash_screen.dart                    # Splash screen
│   │
│   ├── kesehatan/
│   │   ├── kategori_organ.dart              # ✅ Uses API
│   │   ├── kategori_penyakit.dart           # ✅ Uses API
│   │   ├── detail_penyakit.dart             # Disease detail
│   │   └── data_penyakit.dart               # Mock data
│   │
│   ├── jadwal_praktek/
│   │   └── jadwal_praktek.dart              # ✅ Uses API
│   │
│   └── pelayanan/
│       └── pelayanan.dart                    # ✅ Uses API
│
├── pubspec.yaml                              # Dependencies
├── APP_DOKTER_API_INTEGRATION.md            # ⭐ Integration guide
├── TROUBLESHOOTING_GUIDE.md                 # Troubleshooting
└── README.md                                 # This file
```

---

## 🔌 API Endpoints Connected

| Endpoint | Screen | Status |
|----------|--------|--------|
| `/organ.php` | Kategori Organ | ✅ Connected |
| `/penyakit.php` | Kategori Penyakit | ✅ Connected |
| `/penyakit.php?id=X` | Detail Penyakit | ✅ Connected |
| `/profil_dokter.php` | Profil Dokter | ✅ Connected |
| `/jadwal_praktek.php` | Jadwal Praktik | ✅ Connected |
| `/pelayanan.php` | Pelayanan | ✅ Connected |

---

## 🎯 Common Tasks

### Task 1: Update Base URL
```
File: lib/config/api_config.dart
Line: static const String baseUrl = '...'
Change to: 'http://localhost/WebDokter/api'
```

### Task 2: Test API Connection
```bash
# Check if API is accessible
curl http://localhost/WebDokter/api

# Test specific endpoint
curl http://localhost/WebDokter/api/organ.php

# Should return JSON with data
```

### Task 3: View API Response in App
```dart
// Add logging in api_service.dart _get method:
print('API RESPONSE: ${response.body}');
```

### Task 4: Run App with Verbose Logging
```bash
flutter run -v
```

### Task 5: Use Emulator with Real Device IP
```dart
// Find computer IP:
// Windows: ipconfig
// Result: e.g., 192.168.1.100

// Update api_config.dart:
static const String baseUrl = 'http://192.168.1.100/WebDokter/api';
```

---

## 📦 Features Included

### API Client
✅ RESTful API integration  
✅ Error handling  
✅ Timeout management  
✅ JSON parsing  

### Helper Functions
✅ Retry logic with exponential backoff  
✅ Response caching  
✅ Network connectivity checking  
✅ Debug logging  

### Models
✅ Organ data  
✅ Disease information  
✅ Doctor profile  
✅ Schedules  
✅ Services  

### Screens
✅ Organ list with search  
✅ Disease by category  
✅ Disease detail view  
✅ Doctor profile  
✅ Practice schedules  
✅ Medical services  

---

## 🧪 Testing Checklist

- [ ] XAMPP running (Apache + MySQL)
- [ ] WebDokter database exists
- [ ] API endpoints accessible via browser
- [ ] Flutter project opens without errors
- [ ] `flutter pub get` completed successfully
- [ ] API config updated with correct base URL
- [ ] App starts without crashes
- [ ] Screens load data from API
- [ ] Search functionality works
- [ ] Error handling works (test offline)
- [ ] All endpoints return data

---

## 🔐 Security Notes

1. **For Development Only**
   - Current setup is for local development
   - No authentication required

2. **For Production**
   - Use HTTPS instead of HTTP
   - Implement API authentication/tokens
   - Add rate limiting
   - Validate all user inputs
   - Don't expose API errors to users

3. **Best Practices**
   - Never hardcode credentials
   - Use environment variables for configuration
   - Implement proper error logging
   - Monitor API usage

---

## 📞 Getting Help

### 1. Check Documentation
- 📖 [APP_DOKTER_API_INTEGRATION.md](./APP_DOKTER_API_INTEGRATION.md) - Main guide
- 🐛 [TROUBLESHOOTING_GUIDE.md](./TROUBLESHOOTING_GUIDE.md) - Problem solving
- 📚 [WebDokter API Docs](../WebDokter/api/README.md) - Backend documentation

### 2. Test API Directly
- 🧪 [API Tester](../WebDokter/api/examples/api_tester.html) - Interactive tester
- 📦 [Postman Collection](../WebDokter/api/WebDokter_API.postman_collection.json) - Import to Postman

### 3. Debug Steps
1. Test API with curl: `curl http://localhost/WebDokter/api/organ.php`
2. Check app logs: `flutter run -v`
3. Verify database: Open phpMyAdmin
4. Check XAMPP status: Apache + MySQL running

### 4. Common Issues

**"Connection refused"**
→ Check XAMPP is running and accessible

**"Empty data displayed"**
→ Check database has data and status = 'aktif'

**"JSON decode error"**
→ API returning error, check curl output

**"Model mapping error"**
→ API response format doesn't match model

See [TROUBLESHOOTING_GUIDE.md](./TROUBLESHOOTING_GUIDE.md) for more solutions.

---

## 🎓 Learning Resources

### Flutter & API Integration
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [Flutter FutureBuilder](https://flutter.dev/docs/development/ui/async)
- [REST API Best Practices](https://restfulapi.net/)

### PHP & WebDokter
- [WebDokter API Documentation](../WebDokter/api/README.md)
- [PHP PDO Guide](https://www.php.net/manual/en/book.pdo.php)

### Tools
- [Postman API Client](https://www.postman.com/)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools)
- [Chrome DevTools](https://developer.chrome.com/docs/devtools/)

---

## 🚀 Next Steps

After successful integration:

1. **Enhance UI**
   - Add loading indicators
   - Improve error messages
   - Add animations

2. **Add Features**
   - Search functionality
   - Filtering
   - Favorites
   - Sharing

3. **Performance**
   - Implement caching
   - Lazy loading
   - Image optimization

4. **Production**
   - Setup HTTPS
   - Implement authentication
   - Deploy to app stores
   - Monitor usage

---

## 📊 Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                   FLUTTER APP (APP_DOKTER)              │
│  ┌─────────────────────────────────────────────────┐   │
│  │              UI Screens                         │   │
│  │  - Kategori Organ                               │   │
│  │  - Penyakit Detail                              │   │
│  │  - Profil Dokter                                │   │
│  │  - Jadwal Praktik                               │   │
│  │  - Pelayanan                                    │   │
│  └─────────────────────────────────────────────────┘   │
│                        ↑                                 │
│  ┌─────────────────────────────────────────────────┐   │
│  │         API Service (api_service.dart)          │   │
│  │  - getOrganList()                               │   │
│  │  - getPenyakitList()                            │   │
│  │  - getProfilDokter()                            │   │
│  │  - getJadwalPraktek()                           │   │
│  │  - getPelayananList()                           │   │
│  └─────────────────────────────────────────────────┘   │
│                        ↑                                 │
│  ┌─────────────────────────────────────────────────┐   │
│  │         HTTP Client (http package)              │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          ↓
                   HTTP/REST API
                          ↓
┌─────────────────────────────────────────────────────────┐
│              WebDokter API (PHP Native)                 │
│  http://localhost/WebDokter/api                        │
│  ┌─────────────────────────────────────────────────┐   │
│  │         API Endpoints                           │   │
│  │  - /organ.php                                   │   │
│  │  - /penyakit.php                                │   │
│  │  - /profil_dokter.php                           │   │
│  │  - /jadwal_praktek.php                          │   │
│  │  - /pelayanan.php                               │   │
│  └─────────────────────────────────────────────────┘   │
│                        ↓                                 │
│  ┌─────────────────────────────────────────────────┐   │
│  │      Database Layer (MySQL)                     │   │
│  │  - kategori_organ                               │   │
│  │  - penyakit                                     │   │
│  │  - dokter                                       │   │
│  │  - jadwal                                       │   │
│  │  - layanan_medis                                │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 📝 Version Info

**Package Name:** APP_DOKTER  
**Framework:** Flutter  
**Backend:** PHP Native with MySQL  
**API Version:** 1.0  
**Documentation Version:** 1.0  
**Last Updated:** 2024  

---

## ✅ Completion Checklist

- [ ] Read this README completely
- [ ] Follow APP_DOKTER_API_INTEGRATION.md
- [ ] Update api_config.dart with correct baseUrl
- [ ] Test API endpoint with curl
- [ ] Run `flutter pub get`
- [ ] Run `flutter run`
- [ ] Verify data displays in app
- [ ] Test all screens work correctly
- [ ] Check TROUBLESHOOTING_GUIDE.md if issues occur
- [ ] Deploy to device/production when ready

---

**🎉 Congratulations!**  
Your APP_DOKTER is now ready to integrate with WebDokter API!

For any issues, refer to the troubleshooting guide or check the API documentation.

**Happy Coding! 🚀**
