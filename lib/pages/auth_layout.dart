import 'package:flutter/material.dart';
import '../theme.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GradientHeader(
              bottom: 76,
              child: Column(
                children: [
                  const PulseIcon(size: 30),
                  const SizedBox(height: 4),
                  const Text('SIAGA GEMPA',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            // Kartu putih yang menumpuk di atas header
            Transform.translate(
              offset: const Offset(0, -44),
              child: FadeSlide(
                delay: 150,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(229, 57, 53, 0.18),
                          blurRadius: 28,
                          offset: Offset(0, 12)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Palette.navy)),
                      const SizedBox(height: 4),
                      Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: Palette.headerGradient,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 22),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}