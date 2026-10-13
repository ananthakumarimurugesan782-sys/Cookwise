import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

/// Finds a real (non-AI) photo for each recipe: the dataset gives every recipe its
/// source page URL, and that page's og:image is the photo of that exact dish.
/// Results are cached on the device so each page is fetched once.
class ImageService {
  ImageService._();
  static final ImageService i = ImageService._();
  final Map<int, String> _cache = {};
  final Set<int> _failed = {};
  final Map<int, Future<String?>> _pending = {};
  late SharedPreferences _p;
  int _running = 0;
  final List<Completer<void>> _queue = [];

  Future<void> init() async {
    _p = await SharedPreferences.getInstance();
    final raw = _p.getString('imgcache');
    if (raw != null) {
      (jsonDecode(raw) as Map).forEach((k, v) => _cache[int.parse(k)] = '$v');
    }
  }

  Future<void> _acquire() async {
    if (_running < 4) { _running++; return; }
    final c = Completer<void>();
    _queue.add(c);
    await c.future;
  }

  void _release() {
    if (_queue.isNotEmpty) { _queue.removeAt(0).complete(); } else { _running--; }
  }

  Future<String?> urlFor(Recipe r) {
    if (_cache.containsKey(r.id)) return Future.value(_cache[r.id]);
    if (_failed.contains(r.id) || r.url.isEmpty) return Future.value(null);
    return _pending.putIfAbsent(r.id, () => _fetch(r));
  }

  Future<String?> _fetch(Recipe r) async {
    await _acquire();
    try {
      final res = await http.get(Uri.parse(r.url), headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36',
      }).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final a = RegExp(r'''<meta[^>]+property=["']og:image["'][^>]+content=["']([^"']+)["']''').firstMatch(res.body);
        final b = RegExp(r'''<meta[^>]+content=["']([^"']+)["'][^>]+property=["']og:image["']''').firstMatch(res.body);
        final u = (a ?? b)?.group(1);
        if (u != null && u.startsWith('http')) {
          _cache[r.id] = u;
          await _p.setString('imgcache', jsonEncode(_cache.map((k, v) => MapEntry('$k', v))));
          return u;
        }
      }
    } catch (_) {}
    finally {
      _release();
      _pending.remove(r.id);
    }
    _failed.add(r.id);
    return null;
  }
}
