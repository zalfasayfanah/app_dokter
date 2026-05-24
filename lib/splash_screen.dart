import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Sembunyikan status bar agar full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Animasi fade + scale logo
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Navigasi ke MainShell setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      // Kembalikan status bar sebelum pindah halaman
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // ── Gradient biru sesuai desain ──────────────────────────
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1565C0), // biru lebih terang di pojok
              Color(0xFF1A3C92), // biru utama di tengah
              Color(0xFF0D2657), // biru gelap di bawah
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),

        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Logo ─────────────────────────────────────
                  Image.asset(
                    'assets/images/Logo_eduhealth.png',
                    width:
                        MediaQuery.of(context).size.width *
                        0.85, // 85% lebar layar
                    height: 100,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 20),

                  // ── Nama Aplikasi ─────────────────────────────
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Edu',
                          style: TextStyle(
                            color: Color(0xFFFBBF24), // kuning
                            fontWeight: FontWeight.w800,
                            fontSize: 36,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextSpan(
                          text: 'Health',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 36,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Tagline ───────────────────────────────────
                  const Text(
                    'PLATFORM EDUKASI DOKTER SPESIALIS\nPENYAKIT DALAM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      height: 1.6,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
