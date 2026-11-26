import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/bmkg_page.dart';
import 'pages/login_page.dart';
import 'pages/notes_page.dart';
import 'pages/skala_page.dart';
import 'pages/splash_page.dart';
import 'pages/tips_page.dart';
import 'services/api.dart';
import 'theme.dart';

const merah = Palette.red;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.loadSession();
  runApp(const SiagaGempaApp());
}

class SiagaGempaApp extends StatelessWidget {
  const SiagaGempaApp({super.key});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );

    return MaterialApp(
      title: 'Siaga Gempa Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Palette.red,
        scaffoldBackgroundColor: Palette.cream,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Palette.red,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          enabledBorder: border(Colors.grey.shade300),
          focusedBorder: border(Palette.red, 2),
          errorBorder: border(Palette.deepRed),
          focusedErrorBorder: border(Palette.deepRed, 2),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Palette.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<Map<String, dynamic>> _quake = Api.latestQuake();

  static const tips = [
    'Gempa tidak bisa diprediksi, tapi kesiapsiagaan bisa menyelamatkan nyawa.',
    'Siapkan tas siaga: air, makanan, senter, P3K, dan dokumen penting.',
    'Saat gempa di dalam ruangan: Drop, Cover, Hold On di bawah meja kokoh.',
    'Kenali jalur evakuasi dan titik kumpul di rumah dan tempat kerja.',
    'Jauhi kaca, lemari, dan benda yang mudah jatuh saat gempa.',
    'Simpan nomor darurat keluarga di tempat yang mudah dijangkau.',
    'Setelah gempa, waspadai gempa susulan dan cek kondisi gas dan listrik.',
  ];

  String _salam() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat pagi';
    if (h < 15) return 'Selamat siang';
    if (h < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  Future<void> _logout() async {
    await Api.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Widget _quakeCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _quake,
      builder: (context, snap) {
        Widget content;
        if (snap.connectionState != ConnectionState.done) {
          content = const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
          );
        } else if (snap.hasError) {
          content = const Center(
            child: Text('Ketuk untuk melihat info gempa BMKG',
                style: TextStyle(color: Colors.white70)),
          );
        } else {
          final g = snap.data!;
          final mag = double.tryParse('${g['Magnitude']}') ?? 0;
          final c = mag >= 6
              ? Palette.deepRed
              : mag >= 5
                  ? Palette.red
                  : mag >= 4
                      ? Palette.orange
                      : Palette.teal;
          content = Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c,
                  boxShadow: [
                    BoxShadow(color: c.withAlpha(120), blurRadius: 12),
                  ],
                ),
                alignment: Alignment.center,
                child: Text('${g['Magnitude']}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('GEMPA TERKINI',
                        style: TextStyle(
                            color: Palette.amber,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1)),
                    Text('${g['Wilayah']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                    Text('${g['Tanggal']}, ${g['Jam']}',
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          );
        }

        return GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const BmkgPage())),
          child: Container(
            height: 104,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF2B3A5F), Palette.navy]),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                    color: Palette.navy.withAlpha(80),
                    blurRadius: 14,
                    offset: const Offset(0, 6)),
              ],
            ),
            child: content,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = Api.userName ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'S';
    final tip = tips[DateTime.now().day % tips.length];

    final menu = <(IconData, String, String, List<Color>, Widget)>[
      (Icons.home_repair_service, 'Antisipasi', 'Evakuasi & persiapan',
          [Palette.amber, Palette.orange], const TipsPage()),
      (Icons.vibration, 'Skala Gempa', 'Tingkat MMI I - XII',
          [Palette.red, Palette.deepRed], const SkalaPage()),
      (Icons.public, 'Info BMKG', 'Gempa terkini',
          [const Color(0xFF3A4A75), Palette.navy], const BmkgPage()),
      (Icons.edit_note, 'Catatan Siaga', 'Tas, kontak, titik kumpul',
          [const Color(0xFF2ED3C0), const Color(0xFF0E9F90)], const NotesPage()),
    ];

    return Scaffold(
      backgroundColor: Palette.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GradientHeader(
              bottom: 36,
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            const Color.fromRGBO(255, 255, 255, 0.25),
                        child: Text(initial,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_salam(),
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            Text(name.isEmpty ? 'Sahabat Siaga' : name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Keluar',
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: _logout,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.18),
                            blurRadius: 16,
                            offset: Offset(0, 6)),
                      ],
                    ),
                    child: const Icon(Icons.location_on,
                        size: 44, color: Palette.red),
                  ),
                  const SizedBox(height: 12),
                  const Text('SIAGA GEMPA',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3)),
                  const Text('Catat, siapkan, dan selamatkan diri',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            FadeSlide(
              delay: 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _quakeCard(),
              ),
            ),
            FadeSlide(
              delay: 200,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.06),
                        blurRadius: 12,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Palette.orange.withAlpha(35)),
                      child:
                          const Icon(Icons.lightbulb, color: Palette.orange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tips Siaga Hari Ini',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Palette.navy)),
                          const SizedBox(height: 2),
                          Text(tip,
                              style: const TextStyle(
                                  fontSize: 12.5, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.95,
              children: [
                for (var i = 0; i < menu.length; i++)
                  FadeSlide(
                    delay: 300 + i * 90,
                    child: _MenuCard(
                      icon: menu[i].$1,
                      title: menu[i].$2,
                      subtitle: menu[i].$3,
                      colors: menu[i].$4,
                      page: menu[i].$5,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final Widget page;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
              color: colors.last.withAlpha(70),
              blurRadius: 14,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => page)),
            child: Stack(
              children: [
                Positioned(
                  right: -14,
                  bottom: -14,
                  child: Icon(icon,
                      size: 100,
                      color: const Color.fromRGBO(255, 255, 255, 0.2)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 255, 255, 0.25)),
                        child: Icon(icon, color: Colors.white),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(subtitle,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}