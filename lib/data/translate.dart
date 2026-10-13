import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'repo.dart';

/// Translates recipe text that only exists in English (cooking steps, unusual ingredient names)
/// with the Google Cloud Translation API. Needs an API key:
///   flutter run --dart-define=TRANSLATE_API_KEY=your_key
/// Without a key the text simply stays in English. Results are cached on the device.
class Translate {
  Translate._();
  static final Translate i = Translate._();
  static const _key = String.fromEnvironment('TRANSLATE_API_KEY');
  static const codes = {'Tamil': 'ta', 'Hindi': 'hi', 'Telugu': 'te', 'Malayalam': 'ml', 'Kannada': 'kn'};

  final Map<String, String> _cache = {};
  final Map<String, Completer<String>> _waiting = {};
  Timer? _timer;
  late SharedPreferences _p;

  bool get enabled => _key.isNotEmpty && codes.containsKey(Repo.i.language);
  String _k(String s) => '${codes[Repo.i.language]}|$s';

  Future<void> init() async {
    _p = await SharedPreferences.getInstance();
    final raw = _p.getString('trcache');
    if (raw != null) (jsonDecode(raw) as Map).forEach((k, v) => _cache['$k'] = '$v');
  }

  /// Translates a list (same order). Falls back to the original text on any error.
  Future<List<String>> many(List<String> texts) async {
    if (!enabled) return texts;
    final todo = <String>{for (final t in texts) if (!_cache.containsKey(_k(t))) t}.toList();
    for (var s = 0; s < todo.length; s += 100) {
      final chunk = todo.sublist(s, s + 100 > todo.length ? todo.length : s + 100);
      try {
        final res = await http
            .post(Uri.parse('https://translation.googleapis.com/language/translate/v2?key=$_key'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({'q': chunk, 'source': 'en', 'target': codes[Repo.i.language], 'format': 'text'}))
            .timeout(const Duration(seconds: 15));
        if (res.statusCode == 200) {
          final list = jsonDecode(res.body)['data']['translations'] as List;
          for (var i = 0; i < chunk.length && i < list.length; i++) {
            _cache[_k(chunk[i])] = '${list[i]['translatedText']}';
          }
        }
      } catch (_) {}
    }
    if (todo.isNotEmpty) await _p.setString('trcache', jsonEncode(_cache));
    return [for (final t in texts) _cache[_k(t)] ?? t];
  }

  /// One string; requests made close together are sent as a single batch.
  Future<String> text(String s) {
    if (!enabled) return Future.value(s);
    final c = _cache[_k(s)];
    if (c != null) return Future.value(c);
    final w = _waiting.putIfAbsent(s, () => Completer<String>());
    _timer ??= Timer(const Duration(milliseconds: 40), _flush);
    return w.future;
  }

  Future<void> _flush() async {
    _timer = null;
    final batch = Map<String, Completer<String>>.from(_waiting);
    _waiting.clear();
    final keys = batch.keys.toList();
    final out = await many(keys);
    for (var i = 0; i < keys.length; i++) {
      batch[keys[i]]!.complete(out[i]);
    }
  }
}
