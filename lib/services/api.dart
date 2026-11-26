import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // Emulator Android -> 10.0.2.2 | HP asli -> IP laptop, mis. http://192.168.1.5:8000/api
  static const String base = 'http://10.0.2.2:8000/api';

  static String? token;
  static String? userName;

  static Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static dynamic _handle(http.Response r) {
    final body = r.body.isNotEmpty ? jsonDecode(r.body) : null;
    if (r.statusCode < 200 || r.statusCode >= 300) {
      String msg = 'Gagal (${r.statusCode})';
      if (body is Map) {
        if (body['errors'] is Map && (body['errors'] as Map).isNotEmpty) {
          msg = (body['errors'] as Map).values.first.first.toString();
        } else if (body['message'] != null) {
          msg = body['message'].toString();
        }
      }
      throw Exception(msg);
    }
    return body;
  }

  // ---------- Sesi login ----------
  static Future<void> loadSession() async {
    final p = await SharedPreferences.getInstance();
    token = p.getString('token');
    userName = p.getString('name');
  }

  static Future<void> _saveSession(String? t, String? name) async {
    final p = await SharedPreferences.getInstance();
    token = t;
    userName = name;
    if (t == null) {
      await p.remove('token');
      await p.remove('name');
    } else {
      await p.setString('token', t);
      await p.setString('name', name ?? '');
    }
  }

  static Future<void> register(String name, String email, String password) async {
    final res = _handle(await http.post(Uri.parse('$base/register'),
        headers: _headers,
        body: jsonEncode({'name': name, 'email': email, 'password': password})));
    await _saveSession(res['token'], res['user']['name']);
  }

  static Future<void> login(String email, String password) async {
    final res = _handle(await http.post(Uri.parse('$base/login'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password})));
    await _saveSession(res['token'], res['user']['name']);
  }

  static Future<void> logout() async {
    try {
      await http.post(Uri.parse('$base/logout'), headers: _headers);
    } catch (_) {}
    await _saveSession(null, null);
  }

  // ---------- Catatan (Laravel) ----------
  static Future<List<dynamic>> getNotes() async =>
      _handle(await http.get(Uri.parse('$base/notes'), headers: _headers));

  static Future<void> createNote(Map<String, dynamic> data) async => _handle(
      await http.post(Uri.parse('$base/notes'),
          headers: _headers, body: jsonEncode(data)));

  static Future<void> updateNote(int id, Map<String, dynamic> data) async =>
      _handle(await http.put(Uri.parse('$base/notes/$id'),
          headers: _headers, body: jsonEncode(data)));

  static Future<void> deleteNote(int id) async =>
      _handle(await http.delete(Uri.parse('$base/notes/$id'), headers: _headers));

  // ---------- BMKG (gempa terkini) ----------
  static Future<Map<String, dynamic>> latestQuake() async {
    final r = await http
        .get(Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json'));
    final json = _handle(r);
    return Map<String, dynamic>.from(json['Infogempa']['gempa']);
  }

  static String shakemapUrl(String file) =>
      'https://data.bmkg.go.id/DataMKG/TEWS/$file';
}