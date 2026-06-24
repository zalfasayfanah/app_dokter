# Backend API Contoh untuk Flutter App Dokter

Panduan ini menunjukkan cara membuat backend API untuk aplikasi Flutter menggunakan berbagai framework.

## 📋 Opsi Backend

Pilih salah satu sesuai preferensi Anda:

1. [PHP Native + MySQL](#php-native--mysql) - Simple & Lightweight
2. [Laravel + MySQL](#laravel--mysql) - Professional & Full-featured
3. [Node.js/Express + MongoDB](#nodejs-express--mongodb) - Modern & Scalable
4. [Python/Flask + SQLite](#python-flask--sqlite) - Easy to Learn

---

## Option 1: PHP Native + MySQL

### Setup Database

```sql
-- Create Database
CREATE DATABASE app_dokter;
USE app_dokter;

-- Tabel Jadwal Praktik
CREATE TABLE jadwal_praktek (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nama VARCHAR(100) NOT NULL,
  alamat VARCHAR(255) NOT NULL,
  imageUrl VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Jadwal Detail
CREATE TABLE jadwal_detail (
  id INT PRIMARY KEY AUTO_INCREMENT,
  jadwal_praktek_id INT NOT NULL,
  hari VARCHAR(20) NOT NULL,
  jam VARCHAR(50) NOT NULL,
  FOREIGN KEY (jadwal_praktek_id) REFERENCES jadwal_praktek(id) ON DELETE CASCADE
);

-- Tabel Profil Dokter
CREATE TABLE profil_dokter (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nama VARCHAR(100) NOT NULL,
  spesialisasi VARCHAR(100) NOT NULL,
  pengalaman VARCHAR(50) NOT NULL,
  biodata TEXT,
  fotoProfil VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Sertifikat
CREATE TABLE sertifikat (
  id INT PRIMARY KEY AUTO_INCREMENT,
  profil_dokter_id INT NOT NULL,
  nama_sertifikat VARCHAR(100) NOT NULL,
  FOREIGN KEY (profil_dokter_id) REFERENCES profil_dokter(id) ON DELETE CASCADE
);

-- Tabel Organ
CREATE TABLE organ (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nama VARCHAR(50) NOT NULL,
  deskripsi VARCHAR(255),
  iconName VARCHAR(50),
  gambar VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Penyakit
CREATE TABLE penyakit (
  id INT PRIMARY KEY AUTO_INCREMENT,
  organ_id INT NOT NULL,
  nama VARCHAR(100) NOT NULL,
  deskripsi TEXT,
  gejala TEXT,
  penyebab TEXT,
  penanganan TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (organ_id) REFERENCES organ(id) ON DELETE CASCADE
);

-- Tabel Pelayanan
CREATE TABLE pelayanan (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nama VARCHAR(100) NOT NULL,
  deskripsi TEXT,
  icon VARCHAR(50),
  gambar VARCHAR(255),
  harga DECIMAL(10, 2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO jadwal_praktek (nama, alamat, imageUrl) VALUES
('RS UNIMUS', 'Jl. Kedungmundu No.214', 'https://placehold.co/120x90/2ecc71/ffffff?text=RS+UNIMUS'),
('RS Kariadi', 'Jl. Dr. Sutomo No.16', 'https://placehold.co/120x90/3b82f6/ffffff?text=RS+Kariadi');

INSERT INTO jadwal_detail (jadwal_praktek_id, hari, jam) VALUES
(1, 'Senin', '08.00 - 12.00'),
(1, 'Selasa', '08.00 - 12.00'),
(1, 'Rabu', '08.00 - 12.00');

INSERT INTO profil_dokter (nama, spesialisasi, pengalaman, biodata, fotoProfil) VALUES
('Dr. Arif Rahman, Sp.PD', 'Spesialis Penyakit Dalam & Terapi Regeneratif', '10+ Tahun', 'Dokter berpengalaman...', 'assets/images/dokter.png');

INSERT INTO sertifikat (profil_dokter_id, nama_sertifikat) VALUES
(1, 'FINASIM'),
(1, 'FINEM'),
(1, 'AIFO-K'),
(1, 'FISQua');

INSERT INTO organ (nama, deskripsi, iconName, gambar) VALUES
('Jantung', 'Masalah Jantung, Pembuluh Darah dan Sirkulasi', 'favorite', 'jantung.jpg'),
('Paru-Paru', 'Masalah Paru-paru dan Saluran Pernafasan', 'air', 'paru.jpg'),
('Otak', 'Gangguan Pada Otak dan Saraf', 'psychology', 'otak.jpg');
```

### PHP API Endpoints

**File: `api/jadwal-praktek.php`**

```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');

require_once 'config/db.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['id'])) {
        // Get by ID
        $id = $_GET['id'];
        $query = "SELECT jp.*, GROUP_CONCAT(
                    JSON_OBJECT('hari', jd.hari, 'jam', jd.jam)
                  ) as jadwal 
                  FROM jadwal_praktek jp
                  LEFT JOIN jadwal_detail jd ON jp.id = jd.jadwal_praktek_id
                  WHERE jp.id = ?
                  GROUP BY jp.id";
        
        $stmt = $conn->prepare($query);
        $stmt->bind_param('i', $id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($row = $result->fetch_assoc()) {
            echo json_encode([
                'success' => true,
                'message' => 'Detail jadwal praktik berhasil diambil',
                'data' => [
                    'id' => $row['id'],
                    'nama' => $row['nama'],
                    'alamat' => $row['alamat'],
                    'imageUrl' => $row['imageUrl'],
                    'jadwal' => json_decode('[' . $row['jadwal'] . ']')
                ]
            ]);
        } else {
            http_response_code(404);
            echo json_encode([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ]);
        }
    } else {
        // Get all
        $query = "SELECT jp.*, GROUP_CONCAT(
                    JSON_OBJECT('hari', jd.hari, 'jam', jd.jam)
                  ) as jadwal 
                  FROM jadwal_praktek jp
                  LEFT JOIN jadwal_detail jd ON jp.id = jd.jadwal_praktek_id
                  GROUP BY jp.id";
        
        $result = $conn->query($query);
        $data = [];
        
        while ($row = $result->fetch_assoc()) {
            $data[] = [
                'id' => $row['id'],
                'nama' => $row['nama'],
                'alamat' => $row['alamat'],
                'imageUrl' => $row['imageUrl'],
                'jadwal' => json_decode('[' . $row['jadwal'] . ']')
            ];
        }
        
        echo json_encode([
            'success' => true,
            'message' => 'Data jadwal praktik berhasil diambil',
            'data' => $data
        ]);
    }
}
?>
```

**File: `config/db.php`**

```php
<?php
$servername = "localhost";
$username = "root";
$password = "";
$database = "app_dokter";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die(json_encode([
        'success' => false,
        'message' => 'Connection failed: ' . $conn->connect_error
    ]));
}

// Set charset
$conn->set_charset("utf8");
?>
```

---

## Option 2: Laravel + MySQL

### Setup Laravel Project

```bash
# Install Laravel
composer create-project laravel/laravel app-dokter-api

# Install dependencies
cd app-dokter-api
composer install

# Setup env
cp .env.example .env
php artisan key:generate

# Setup database
php artisan migrate
php artisan db:seed
```

### Create Models & Controllers

```bash
# Create models and controllers
php artisan make:model JadwalPraktek -m -c
php artisan make:model ProfilDokter -m -c
php artisan make:model Organ -m -c
php artisan make:model Penyakit -m -c
php artisan make:model Pelayanan -m -c
```

### Model Example: `app/Models/JadwalPraktek.php`

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class JadwalPraktek extends Model
{
    protected $fillable = ['nama', 'alamat', 'imageUrl'];

    public function jadwalDetail(): HasMany
    {
        return $this->hasMany(JadwalDetail::class);
    }

    protected $appends = ['jadwal'];

    public function getJadwalAttribute()
    {
        return $this->jadwalDetail->map(function ($item) {
            return [
                'hari' => $item->hari,
                'jam' => $item->jam
            ];
        });
    }
}
```

### Controller Example: `app/Http/Controllers/JadwalPraktekController.php`

```php
<?php

namespace App\Http\Controllers;

use App\Models\JadwalPraktek;
use Illuminate\Http\JsonResponse;

class JadwalPraktekController extends Controller
{
    public function index(): JsonResponse
    {
        $jadwal = JadwalPraktek::with('jadwalDetail')->get();

        return response()->json([
            'success' => true,
            'message' => 'Data jadwal praktik berhasil diambil',
            'data' => $jadwal
        ]);
    }

    public function show($id): JsonResponse
    {
        $jadwal = JadwalPraktek::with('jadwalDetail')->find($id);

        if (!$jadwal) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail jadwal praktik berhasil diambil',
            'data' => $jadwal
        ]);
    }
}
```

### Routes: `routes/api.php`

```php
<?php

use App\Http\Controllers\JadwalPraktekController;
use App\Http\Controllers\ProfilDokterController;
use App\Http\Controllers\OrganController;
use App\Http\Controllers\PenyakitController;
use App\Http\Controllers\PelayananController;

Route::prefix('api')->group(function () {
    // Jadwal Praktik
    Route::get('/jadwal-praktek', [JadwalPraktekController::class, 'index']);
    Route::get('/jadwal-praktek/{id}', [JadwalPraktekController::class, 'show']);

    // Profil Dokter
    Route::get('/profil-dokter', [ProfilDokterController::class, 'index']);

    // Organ
    Route::get('/organ', [OrganController::class, 'index']);

    // Penyakit
    Route::get('/penyakit', [PenyakitController::class, 'index']);
    Route::get('/penyakit/{id}', [PenyakitController::class, 'show']);

    // Pelayanan
    Route::get('/pelayanan', [PelayananController::class, 'index']);
});
```

### Setup CORS (Middleware: `app/Http/Middleware/Cors.php`)

```php
<?php

namespace App\Http\Middleware;

use Closure;

class Cors
{
    public function handle($request, Closure $next)
    {
        return $next($request)
            ->header('Access-Control-Allow-Origin', '*')
            ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
            ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    }
}
```

Register di `app/Http/Kernel.php`:

```php
protected $middleware = [
    // ... other middleware
    \App\Http\Middleware\Cors::class,
];
```

---

## Option 3: Node.js/Express + MongoDB

### Setup Project

```bash
# Create project
mkdir app-dokter-api
cd app-dokter-api
npm init -y

# Install dependencies
npm install express mongoose cors dotenv body-parser

# Create folder structure
mkdir routes models controllers config
```

### Config: `config/db.js`

```javascript
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/app_dokter');
    console.log('MongoDB connected');
  } catch (err) {
    console.error('Connection error:', err);
    process.exit(1);
  }
};

module.exports = connectDB;
```

### Model: `models/JadwalPraktek.js`

```javascript
const mongoose = require('mongoose');

const jadwalDetailSchema = new mongoose.Schema({
  hari: String,
  jam: String
});

const jadwalPraktekSchema = new mongoose.Schema({
  nama: String,
  alamat: String,
  imageUrl: String,
  jadwal: [jadwalDetailSchema],
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('JadwalPraktek', jadwalPraktekSchema);
```

### Controller: `controllers/jadwalPraktekController.js`

```javascript
const JadwalPraktek = require('../models/JadwalPraktek');

exports.getAll = async (req, res) => {
  try {
    const data = await JadwalPraktek.find();
    res.json({
      success: true,
      message: 'Data jadwal praktik berhasil diambil',
      data
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message
    });
  }
};

exports.getById = async (req, res) => {
  try {
    const data = await JadwalPraktek.findById(req.params.id);
    if (!data) {
      return res.status(404).json({
        success: false,
        message: 'Data tidak ditemukan'
      });
    }
    res.json({
      success: true,
      message: 'Detail jadwal praktik berhasil diambil',
      data
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message
    });
  }
};
```

### Routes: `routes/jadwalPraktek.js`

```javascript
const express = require('express');
const router = express.Router();
const jadwalController = require('../controllers/jadwalPraktekController');

router.get('/', jadwalController.getAll);
router.get('/:id', jadwalController.getById);

module.exports = router;
```

### Main Server: `server.js`

```javascript
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const jadwalPraktekRoutes = require('./routes/jadwalPraktek');

dotenv.config();
const app = express();

// Connect to DB
connectDB();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/jadwal-praktek', jadwalPraktekRoutes);

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### Run Server

```bash
npm start
# atau gunakan nodemon untuk development
npm install -D nodemon
npx nodemon server.js
```

---

## Option 4: Python/Flask + SQLite

### Setup Project

```bash
# Create project
mkdir app_dokter_api
cd app_dokter_api

# Create virtual environment
python -m venv venv

# Activate venv
# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate

# Install dependencies
pip install flask flask-cors flask-sqlalchemy
```

### Models: `models.py`

```python
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class JadwalPraktek(db.Model):
    __tablename__ = 'jadwal_praktek'
    
    id = db.Column(db.Integer, primary_key=True)
    nama = db.Column(db.String(100), nullable=False)
    alamat = db.Column(db.String(255), nullable=False)
    imageUrl = db.Column(db.String(255))
    jadwal = db.relationship('JadwalDetail', backref='praktek', lazy=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'nama': self.nama,
            'alamat': self.alamat,
            'imageUrl': self.imageUrl,
            'jadwal': [j.to_dict() for j in self.jadwal]
        }

class JadwalDetail(db.Model):
    __tablename__ = 'jadwal_detail'
    
    id = db.Column(db.Integer, primary_key=True)
    jadwal_praktek_id = db.Column(db.Integer, db.ForeignKey('jadwal_praktek.id'), nullable=False)
    hari = db.Column(db.String(20), nullable=False)
    jam = db.Column(db.String(50), nullable=False)

    def to_dict(self):
        return {
            'hari': self.hari,
            'jam': self.jam
        }
```

### Routes: `routes.py`

```python
from flask import Blueprint, jsonify
from models import JadwalPraktek, db

jadwal_bp = Blueprint('jadwal', __name__, url_prefix='/api')

@jadwal_bp.route('/jadwal-praktek', methods=['GET'])
def get_all_jadwal():
    jadwal = JadwalPraktek.query.all()
    return jsonify({
        'success': True,
        'message': 'Data jadwal praktik berhasil diambil',
        'data': [j.to_dict() for j in jadwal]
    })

@jadwal_bp.route('/jadwal-praktek/<int:id>', methods=['GET'])
def get_jadwal_by_id(id):
    jadwal = JadwalPraktek.query.get(id)
    
    if not jadwal:
        return jsonify({
            'success': False,
            'message': 'Data tidak ditemukan'
        }), 404
    
    return jsonify({
        'success': True,
        'message': 'Detail jadwal praktik berhasil diambil',
        'data': jadwal.to_dict()
    })
```

### Main App: `app.py`

```python
from flask import Flask
from flask_cors import CORS
from models import db
from routes import jadwal_bp

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app_dokter.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

CORS(app)
db.init_app(app)

app.register_blueprint(jadwal_bp)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, port=5000)
```

### Run Server

```bash
python app.py
# Server akan berjalan di http://localhost:5000
```

---

## Testing API

Gunakan Postman atau curl:

```bash
# Test GET jadwal-praktek
curl http://localhost:8000/api/jadwal-praktek

# Test GET jadwal-praktek by ID
curl http://localhost:8000/api/jadwal-praktek/1
```

---

## Deployment

Untuk production, gunakan:
- **PHP**: Hosting dengan PHP 8+
- **Laravel**: Heroku, Railway, DigitalOcean
- **Node.js**: Heroku, Vercel, DigitalOcean, AWS
- **Python**: Heroku, PythonAnywhere, Render

---

Pilih backend yang sesuai dengan keahlian Anda dan kembangkan lebih lanjut!
