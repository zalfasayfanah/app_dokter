import 'package:flutter/material.dart';

// ─── EduHealthBottomNav ───────────────────────────────────────────────────────
//
// Widget navigasi bawah bersama untuk semua laman EduHealth.
//
// Cara pakai di halaman mana pun:
//
//   import '../bottom_nav.dart'; // sesuaikan path relatif dari lokasimu
//
//   Scaffold(
//     body: ...,
//     bottomNavigationBar: EduHealthBottomNav(
//       currentIndex: _currentIndex,
//       onTap: (index) => setState(() => _currentIndex = index),
//     ),
//   );
//
// Catatan: pengelolaan index & perpindahan halaman dilakukan di main.dart (MainShell).
// Halaman individual TIDAK perlu menyimpan state index — cukup pakai widget ini.

class EduHealthBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const EduHealthBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color _navBg         = Color(0xFF1A3C92);
  static const Color _activeColor   = Color(0xFFFBBF24); // ← diganti kuning
  static const Color _inactiveColor = Color.fromARGB(255, 255, 255, 255); // white 50%

  // Urutan tab — sesuaikan dengan urutan _pages di MainShell (main.dart)
  // Tab ke-4 diubah dari "Profil" → "Pelayanan"
  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded,             label: 'Beranda'),
    _NavItem(icon: Icons.calendar_month_rounded,   label: 'Jadwal'),
    _NavItem(icon: Icons.favorite_rounded,         label: 'Kesehatan'),
    _NavItem(icon: Icons.medical_services_rounded, label: 'Pelayanan'), // ← diganti
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _navBg,
        borderRadius: BorderRadius.only(
          topLeft:  Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, _buildTab),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    final bool selected = currentIndex == index;
    final item          = _items[index];

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent, // ← kotak dihilangkan (selalu transparan)
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon
            Icon(
              item.icon,
              color: selected ? _activeColor : _inactiveColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            // Label teks di bawah ikon
            Text(
              item.label,
              style: TextStyle(
                fontSize:   10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color:      selected ? _activeColor : _inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Internal model ───────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String   label;
  const _NavItem({required this.icon, required this.label});
}