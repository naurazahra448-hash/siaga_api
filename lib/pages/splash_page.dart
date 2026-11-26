import 'package:flutter/material.dart';
import '../main.dart';
import '../services/api.dart';
import '../theme.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) =>
              Api.token == null ? const LoginPage() : const HomePage(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: Palette.splashGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            PulseIcon(size: 52),
            SizedBox(height: 8),
            FadeSlide(
              delay: 300,
              child: Text('SIAGA GEMPA',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4)),
            ),
            SizedBox(height: 6),
            FadeSlide(
              delay: 600,
              child: Text('Catat, siapkan, dan selamatkan diri',
                  style: TextStyle(color: Colors.white70)),
            ),
            SizedBox(height: 48),
            FadeSlide(
              delay: 900,
              child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}