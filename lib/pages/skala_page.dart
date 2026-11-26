import 'package:flutter/material.dart';
import '../theme.dart';

class SkalaPage extends StatelessWidget {
  const SkalaPage({super.key});

  // (angka, kategori, deskripsi, anjuran, warna)
  static const data = <(String, String, String, String, Color)>[
    ('I', 'Tidak terasa', 'Tidak dirasakan manusia, hanya tercatat oleh alat.',
        'Tetap tenang, tidak ada tindakan khusus.', Color(0xFFB0BEC5)),
    ('II', 'Tidak terasa', 'Dirasakan sebagian kecil orang yang diam; benda ringan yang digantung bergoyang.',
        'Tetap tenang, tidak perlu evakuasi.', Color(0xFF4FC3F7)),
    ('III', 'Ringan', 'Dirasakan di dalam rumah, seperti getaran truk yang lewat.',
        'Tetap tenang dan jauhi benda yang bergantung.', Color(0xFF26C6DA)),
    ('IV', 'Ringan', 'Banyak orang merasakan di dalam rumah; piring, jendela, dan pintu bergetar.',
        'Jauhi kaca dan lemari, siap berlindung.', Color(0xFF66BB6A)),
    ('V', 'Sedang', 'Dirasakan hampir semua orang; barang kecil bergeser, orang tidur terbangun.',
        'Berlindung di bawah meja kokoh (Drop, Cover, Hold On).', Color(0xFF9CCC65)),
    ('VI', 'Sedang', 'Dirasakan semua orang, banyak yang berlari keluar; plester dinding retak, genteng bergeser.',
        'Berlindung, lalu keluar ke area terbuka bila aman.', Color(0xFFFDD835)),
    ('VII', 'Kuat', 'Sulit berdiri; kerusakan ringan pada bangunan bagus, sedang pada bangunan kurang kuat.',
        'Lindungi kepala dan menjauh dari bangunan yang retak.', Color(0xFFFFB300)),
    ('VIII', 'Kuat', 'Kerusakan pada bangunan biasa; cerobong dan monumen roboh.',
        'Evakuasi ke lapangan terbuka dan waspadai gempa susulan.', Color(0xFFFB8C00)),
    ('IX', 'Merusak', 'Kerusakan besar pada bangunan; tanah retak, pipa bawah tanah putus.',
        'Evakuasi segera ke area aman dan ikuti arahan BPBD.', Color(0xFFF4511E)),
    ('X', 'Merusak', 'Sebagian besar bangunan rusak; tanah longsor, rel melengkung.',
        'Evakuasi segera, waspadai longsor dan gempa susulan.', Color(0xFFE53935)),
    ('XI', 'Merusak', 'Hampir semua bangunan hancur; jembatan runtuh.',
        'Selamatkan diri dan cari bantuan, ikuti arahan petugas.', Color(0xFFC62828)),
    ('XII', 'Merusak', 'Kerusakan total; benda terlempar ke udara.',
        'Selamatkan diri dan cari bantuan, ikuti arahan petugas.', Color(0xFF7F0000)),
  ];

  Widget _legend() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 12,
              offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Modified Mercalli Intensity',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800, color: Palette.navy)),
          const SizedBox(height: 2),
          const Text('Makin tinggi angkanya, makin besar dampak getarannya.',
              style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 14),
          Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(colors: [for (final d in data) d.$5]),
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('I', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              Text('XII', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card((String, String, String, String, Color) d) {
    final color = d.$5;
    final onColor = color.computeLuminance() > 0.45 ? Palette.navy : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: color.withAlpha(50),
              blurRadius: 12,
              offset: const Offset(0, 5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            splashColor: color.withAlpha(25),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [color, color.withAlpha(200)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(d.$1,
                  style: TextStyle(
                      color: onColor, fontSize: 18, fontWeight: FontWeight.w900)),
            ),
            title: Text('Skala ${d.$1} MMI',
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: Palette.navy)),
            subtitle: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withAlpha(40),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(d.$2,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color.lerp(color, Colors.black, 0.35))),
              ),
            ),
            children: [
              Text(d.$3,
                  style: const TextStyle(color: Colors.black87, height: 1.4)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Palette.cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.tips_and_updates,
                        color: Palette.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(d.$4,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Palette.navy)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skala Gempa (MMI)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FadeSlide(child: _legend()),
          for (var i = 0; i < data.length; i++)
            FadeSlide(delay: 80 + i * 50, child: _card(data[i])),
        ],
      ),
    );
  }
}