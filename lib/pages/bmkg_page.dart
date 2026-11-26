import 'package:flutter/material.dart';
import '../main.dart';
import '../services/api.dart';

class BmkgPage extends StatefulWidget {
  const BmkgPage({super.key});

  @override
  State<BmkgPage> createState() => _BmkgPageState();
}

class _BmkgPageState extends State<BmkgPage> {
  late Future<Map<String, dynamic>> _future = Api.latestQuake();

  Widget _row(IconData icon, String label, String value) => ListTile(
        dense: true,
        leading: Icon(icon, color: merah),
        title: Text(label, style: const TextStyle(fontSize: 12)),
        subtitle: Text(value,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info BMKG')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() => _future = Api.latestQuake()),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: merah));
            }
            if (snap.hasError) {
              return ListView(children: const [
                SizedBox(height: 120),
                Icon(Icons.wifi_off, size: 64, color: merah),
                Center(child: Text('Gagal memuat data BMKG. Cek koneksi internet.')),
              ]);
            }
            final g = snap.data!;
            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Text('Gempabumi Terkini',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: merah)),
                const SizedBox(height: 8),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      if (g['Shakemap'] != null)
                        Image.network(Api.shakemapUrl(g['Shakemap']),
                            errorBuilder: (_, __, ___) => const SizedBox(
                                height: 120,
                                child: Center(child: Icon(Icons.map, size: 48)))),
                      ListTile(
                        title: Text('${g['Tanggal']}, ${g['Jam']}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      _row(Icons.monitor_heart, 'Magnitudo', '${g['Magnitude']}'),
                      _row(Icons.vertical_align_bottom, 'Kedalaman', '${g['Kedalaman']}'),
                      _row(Icons.location_on, 'Lokasi',
                          '${g['Lintang']} - ${g['Bujur']}'),
                      _row(Icons.my_location, 'Pusat gempa', '${g['Wilayah']}'),
                      _row(Icons.sensors, 'Dirasakan (MMI)', '${g['Dirasakan']}'),
                      _row(Icons.warning_amber, 'Potensi', '${g['Potensi']}'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Sumber: BMKG (data.bmkg.go.id)',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}