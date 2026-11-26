import 'package:flutter/material.dart';
import '../theme.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  static const sections = <(String, IconData, Color, List<String>)>[
    ('Evakuasi Diri Saat Gempa', Icons.directions_run, Palette.red, [
      '1. Jangan panik',
      '2. Ketika di dalam ruangan: berlindung di bawah meja kokoh (Drop, Cover, Hold On), jauhi kaca dan lemari',
      '3. Ketika di luar ruangan: menjauh dari gedung, tiang, dan pohon; cari lapangan terbuka',
    ]),
    ('Sebelum Gempa', Icons.backpack, Palette.orange, [
      'Siapkan tas siaga: air minum, makanan, senter, P3K, obat, powerbank, dokumen penting',
      'Kenali jalur evakuasi dan titik kumpul',
      'Amankan perabot berat agar tidak roboh',
      'Simpan nomor darurat keluarga',
    ]),
    ('Setelah Gempa', Icons.health_and_safety, Palette.teal, [
      'Cek kondisi diri dan keluarga, beri pertolongan pertama',
      'Waspadai gempa susulan',
      'Matikan listrik dan gas jika ada kebocoran',
      'Jangan masuk bangunan yang retak; ikuti info resmi BMKG/BPBD',
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Antisipasi Gempa')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FadeSlide(
            child: Container(
              height: 150,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: Palette.splashGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Palette.red.withAlpha(80),
                      blurRadius: 16,
                      offset: const Offset(0, 8)),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -18,
                    child: Icon(Icons.shield,
                        size: 140,
                        color: const Color.fromRGBO(255, 255, 255, 0.2)),
                  ),
                  const Center(
                    child: Text('Evakuasi Diri\nSaat Gempa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ),
          ),
          for (var i = 0; i < sections.length; i++)
            FadeSlide(
              delay: 150 + i * 120,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: sections[i].$3.withAlpha(45),
                        blurRadius: 12,
                        offset: const Offset(0, 5)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(width: 6, color: sections[i].$3),
                      Expanded(
                        child: Theme(
                          data: ThemeData(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: i == 0,
                            leading: CircleAvatar(
                              backgroundColor: sections[i].$3.withAlpha(35),
                              child: Icon(sections[i].$2, color: sections[i].$3),
                            ),
                            title: Text(sections[i].$1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Palette.navy)),
                            children: [
                              for (final t in sections[i].$4)
                                ListTile(
                                  dense: true,
                                  leading: Icon(Icons.check_circle,
                                      color: sections[i].$3),
                                  title: Text(t),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}