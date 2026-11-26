import 'package:flutter/material.dart';
import '../main.dart';
import '../services/api.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  static const kategori = ['Umum', 'Tas Siaga', 'Kontak Darurat', 'Titik Kumpul'];
  late Future<List<dynamic>> _future = Api.getNotes();

  void _reload() => setState(() => _future = Api.getNotes());

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _form([Map<String, dynamic>? note]) async {
    final title = TextEditingController(text: note?['title']);
    final content = TextEditingController(text: note?['content']);
    String cat = note?['category'] ?? 'Umum';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(note == null ? 'Catatan Baru' : 'Edit Catatan',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: merah)),
              const SizedBox(height: 12),
              TextField(
                controller: title,
                decoration: const InputDecoration(
                    labelText: 'Judul', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: content,
                maxLines: 4,
                decoration: const InputDecoration(
                    labelText: 'Isi catatan', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: cat,
                decoration: const InputDecoration(
                    labelText: 'Kategori', border: OutlineInputBorder()),
                items: [
                  for (final k in kategori)
                    DropdownMenuItem(value: k, child: Text(k))
                ],
                onChanged: (v) => setS(() => cat = v!),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: merah),
                  onPressed: () async {
                    final data = {
                      'title': title.text.trim(),
                      'content': content.text.trim(),
                      'category': cat,
                    };
                    try {
                      if (note == null) {
                        await Api.createNote(data);
                      } else {
                        await Api.updateNote(note['id'], data);
                      }
                      if (ctx.mounted) Navigator.pop(ctx);
                      _reload();
                    } catch (e) {
                      _snack('Gagal menyimpan: judul wajib diisi / server mati');
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _icon(String c) => switch (c) {
        'Tas Siaga' => Icons.backpack,
        'Kontak Darurat' => Icons.phone_in_talk,
        'Titik Kumpul' => Icons.flag,
        _ => Icons.sticky_note_2,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Siaga')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: merah,
        foregroundColor: Colors.white,
        onPressed: () => _form(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<dynamic>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: merah));
            }
            if (snap.hasError) {
              return ListView(children: [
                const SizedBox(height: 120),
                const Icon(Icons.cloud_off, size: 64, color: merah),
                const Center(
                    child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'Tidak bisa terhubung ke server Laravel.\nCek Api.base & pastikan php artisan serve jalan.',
                      textAlign: TextAlign.center),
                )),
              ]);
            }
            final notes = snap.data!;
            if (notes.isEmpty) {
              return ListView(children: const [
                SizedBox(height: 160),
                Center(child: Text('Belum ada catatan. Tekan + untuk menambah.')),
              ]);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (_, i) {
                final n = Map<String, dynamic>.from(notes[i]);
                return Dismissible(
                  key: ValueKey(n['id']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: merah,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    await Api.deleteNote(n['id']);
                    _reload();
                  },
                  child: Card(
                    child: ListTile(
                      leading: Icon(_icon(n['category'] ?? 'Umum'), color: merah),
                      title: Text(n['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          '${n['category']}\n${n['content'] ?? ''}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis),
                      isThreeLine: true,
                      onTap: () => _form(n),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}