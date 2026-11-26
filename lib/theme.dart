import 'package:flutter/material.dart';

class Palette {
  static const red = Color(0xFFE53935);
  static const deepRed = Color(0xFFB71C1C);
  static const orange = Color(0xFFFF8A3D);
  static const amber = Color(0xFFFFB300);
  static const navy = Color(0xFF1F2A44);
  static const teal = Color(0xFF1FB6A6);
  static const cream = Color(0xFFFFF6F0);

  static const headerGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFFF7043)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const splashGradient = LinearGradient(
    colors: [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFFFF7043)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Header gradasi merah-oranye dengan lingkaran dekoratif.
class GradientHeader extends StatelessWidget {
  final Widget child;
  final double bottom;

  const GradientHeader({super.key, required this.child, this.bottom = 36});

  static Widget _circle(double size, double alpha) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(255, 255, 255, alpha),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: Palette.headerGradient),
        child: Stack(
          children: [
            Positioned(top: -40, right: -30, child: _circle(160, 0.12)),
            Positioned(bottom: -50, left: -40, child: _circle(130, 0.10)),
            Positioned(top: 70, left: 28, child: _circle(28, 0.15)),
            Padding(
              padding: EdgeInsets.fromLTRB(24, top + 20, 24, bottom),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Animasi muncul: memudar + naik pelan-pelan. [delay] dalam milidetik.
class FadeSlide extends StatefulWidget {
  final Widget child;
  final int delay;

  const FadeSlide({super.key, required this.child, this.delay = 0});

  @override
  State<FadeSlide> createState() => _FadeSlideState();
}

class _FadeSlideState extends State<FadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 550));
  late final Animation<double> _a =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _a,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
            .animate(_a),
        child: widget.child,
      ),
    );
  }
}

/// Ikon lokasi putih dengan gelombang yang berdenyut (seperti getaran gempa).
class PulseIcon extends StatefulWidget {
  final double size;

  const PulseIcon({super.key, this.size = 40});

  @override
  State<PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<PulseIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2400))
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final core = widget.size * 1.9;
    final box = core * 1.9;
    return SizedBox(
      width: box,
      height: box,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          return Stack(
            alignment: Alignment.center,
            children: [
              for (final shift in [0.0, 0.5])
                Builder(builder: (_) {
                  final t = (_c.value + shift) % 1.0;
                  final d = core * (1 + t * 0.9);
                  return Container(
                    width: d,
                    height: d,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.fromRGBO(255, 255, 255, (1 - t) * 0.6),
                        width: 2,
                      ),
                    ),
                  );
                }),
              Container(
                width: core,
                height: core,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.18),
                        blurRadius: 18,
                        offset: Offset(0, 8)),
                  ],
                ),
                child: Icon(Icons.location_on,
                    size: widget.size, color: Palette.red),
              ),
            ],
          );
        },
      ),
    );
  }
}