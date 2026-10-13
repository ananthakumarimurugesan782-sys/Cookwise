import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';
import 'cloud.dart';

/// App-wide state + recipe database (loaded from assets/data/recipes.json,
/// which is generated from dataset.csv by tools_build_recipes.py).
class Repo {
  Repo._();
  static final Repo i = Repo._();

  List<Recipe> all = [];
  final Set<int> favourites = {};
  final Set<String> shopping = {}; // ingredient names marked "need to buy"
  final Set<String> haveAtHome = {};
  Recipe? current;
  int people = 4;
  bool modern = false;
  String language = 'English';
  final Set<String> diet = {};
  late SharedPreferences _p;

  // ---- accounts: online backend (Firebase) when plugged in, otherwise a local demo store ----
  static CloudBackend? cloud;
  Map<String, dynamic> accounts = {};
  String? userId;
  bool get loggedIn => cloud != null ? cloud!.loggedIn : userId != null;
  String? get userName =>
      cloud != null ? cloud!.userName : (userId == null ? null : (accounts[userId] as Map?)?['name'] as String?);

  String _hash(String id, String pw) => sha256.convert(utf8.encode('$id|$pw')).toString();

  /// Returns an English error key, or null on success.
  Future<String?> signUp(String name, String id, String pw) async {
    if (cloud != null) {
      final r = await cloud!.signUp(name, id, pw);
      if (r == null) await _syncFavs();
      return r;
    }
    if (accounts.containsKey(id)) return 'An account with this email/number already exists';
    accounts[id] = {'name': name.trim(), 'hash': _hash(id, pw)};
    userId = id;
    await _p.setString('accounts', jsonEncode(accounts));
    await _p.setString('session', id);
    return null;
  }

  Future<String?> login(String id, String pw) async {
    if (cloud != null) {
      final r = await cloud!.login(id, pw);
      if (r == null) await _syncFavs();
      return r;
    }
    final a = accounts[id] as Map?;
    if (a == null) return 'Account not found. Please sign up first.';
    if (a['hash'] != _hash(id, pw)) return 'Incorrect password';
    userId = id;
    await _p.setString('session', id);
    return null;
  }

  /// Returns null on success, '' if the user cancelled, else an error key.
  Future<String?> googleSignIn() async {
    if (cloud == null) return 'Google sign-in will be available once Firebase is connected';
    final r = await cloud!.googleSignIn();
    if (r == null) await _syncFavs();
    return r;
  }

  Future<String?> resetPassword(String id) async {
    if (id.startsWith('+')) return 'Password reset works with email only';
    if (cloud == null) return null; // demo mode
    return cloud!.resetPassword(id);
  }

  Future<void> logout() async {
    if (cloud != null) {
      await cloud!.logout();
      favourites.clear();
      await _p.remove('fav');
    }
    userId = null;
    await _p.remove('session');
  }

  Future<void> _syncFavs() async {
    final c = cloud;
    if (c == null || !c.loggedIn) return;
    try {
      final remote = await c.loadFavourites();
      for (final id in favourites.difference(remote)) {
        await c.setFavourite(id, true);
      }
      favourites.addAll(remote);
      await _p.setStringList('fav', favourites.map((e) => '$e').toList());
    } catch (_) {}
  }

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    final raw = await rootBundle.loadString('assets/data/recipes.json');
    all = (jsonDecode(raw) as List).map((e) => Recipe.fromJson(e)).toList();
    favourites.addAll((_p.getStringList('fav') ?? []).map(int.parse));
    language = _p.getString('lang') ?? 'English';
    final acc = _p.getString('accounts');
    if (acc != null) accounts = Map<String, dynamic>.from(jsonDecode(acc));
    userId = _p.getString('session');
    if (userId != null && !accounts.containsKey(userId)) userId = null;
    if (cloud?.loggedIn == true) { _syncFavs(); }
    diet.addAll(_p.getStringList('diet') ?? []);
  }

  // ---- dietary preferences (keyword based on the dataset's ingredient names) ----
  static const _meat = ['chicken', 'beef', 'pork', 'lamb', 'mutton', 'bacon', 'ham ', 'sausage', 'turkey', 'fish', 'salmon', 'tuna', 'shrimp', 'prawn', 'crab', 'lobster', 'anchov', 'clam', 'mussel', 'squid', 'steak', 'veal', 'duck', 'pepperoni', 'salami', 'prosciutto', 'gelatin', 'ground meat', 'oyster sauce', 'fish sauce'];
  static const _dairy = ['milk', 'cheese', 'butter', 'cream', 'yogurt', 'yoghurt', 'ghee', 'paneer', 'whey', 'curd', 'mozzarella', 'parmesan', 'ricotta'];
  static const _nuts = ['almond', 'cashew', 'walnut', 'pecan', 'pistachio', 'hazelnut', 'peanut', 'macadamia'];
  static const _plant = ['coconut milk', 'almond milk', 'soy milk', 'oat milk', 'peanut butter', 'cocoa butter', 'coconut cream', 'cream of tartar'];
  static const dietOptions = ['Vegetarian', 'Vegan', 'Dairy-free', 'Egg-free', 'Nut-free'];

  bool _has(Recipe r, List<String> words) => r.ingredients.any((i) {
        var n = ' ${i.name.toLowerCase()} ';
        for (final p in _plant) { n = n.replaceAll(p, ''); }
        return words.any(n.contains);
      });
  bool _egg(Recipe r) => r.ingredients.any((i) => RegExp(r'\begg(s)?\b').hasMatch(i.name.toLowerCase()) && !i.name.toLowerCase().contains('eggplant'));

  bool allowed(Recipe r) {
    if ((diet.contains('Vegetarian') || diet.contains('Vegan')) && _has(r, _meat)) return false;
    if ((diet.contains('Vegan') || diet.contains('Dairy-free')) && _has(r, _dairy)) return false;
    if ((diet.contains('Vegan') || diet.contains('Egg-free')) && (_egg(r) || _has(r, ['honey', 'mayonnaise']) && diet.contains('Vegan'))) return false;
    if (diet.contains('Nut-free') && _has(r, _nuts)) return false;
    return true;
  }

  Future<void> setDiet(Set<String> d) async {
    diet..clear()..addAll(d);
    await _p.setStringList('diet', diet.toList());
  }

  /// Recipes after dietary preferences are applied.
  List<Recipe> get visible => diet.isEmpty ? all : all.where(allowed).toList();

  List<String> get cuisines => all.map((r) => r.cuisine).toSet().toList();
  List<Recipe> byCuisine(String c) => visible.where((r) => r.cuisine == c).toList();

  List<Recipe> search(String q, {String? cuisine}) {
    final s = q.trim().toLowerCase();
    return visible.where((r) {
      if (cuisine != null && r.cuisine != cuisine) return false;
      if (s.isEmpty) return true;
      return r.name.toLowerCase().contains(s) ||
          r.cuisine.toLowerCase().contains(s) ||
          r.ingredients.any((i) => i.name.toLowerCase().contains(s));
    }).toList();
  }

  /// Recipes ranked by how many of the user's ingredients they use.
  List<MapEntry<Recipe, int>> matchIngredients(Set<String> have) {
    final h = have.map((e) => e.toLowerCase()).toList();
    final out = <MapEntry<Recipe, int>>[];
    for (final r in visible) {
      int n = 0;
      for (final i in r.ingredients) {
        final nm = i.name.toLowerCase();
        if (h.any((x) => nm.contains(x))) n++;
      }
      if (n > 0) out.add(MapEntry(r, n));
    }
    out.sort((a, b) {
      final c = b.value.compareTo(a.value);
      return c != 0 ? c : a.key.ingredients.length.compareTo(b.key.ingredients.length);
    });
    return out;
  }

  bool isFav(Recipe r) => favourites.contains(r.id);
  Future<void> toggleFav(Recipe r) async {
    isFav(r) ? favourites.remove(r.id) : favourites.add(r.id);
    await _p.setStringList('fav', favourites.map((e) => '$e').toList());
    if (cloud?.loggedIn == true) {
      try { await cloud!.setFavourite(r.id, isFav(r)); } catch (_) {}
    }
  }

  Future<void> setLanguage(String l) async {
    language = l;
    await _p.setString('lang', l);
  }

  List<Recipe> get favRecipes => all.where((r) => favourites.contains(r.id)).toList();

  /// A wireframe photo is used ONLY when the recipe name is exactly that dish,
  /// so one dish photo can never appear on a different recipe.
  String? imageFor(Recipe r) {
    final n = r.name.toLowerCase().trim();
    const exact = {
      'vegetable biryani': 'img_biryani', 'vegetable biriyani': 'img_biryani', 'veg biryani': 'img_biryani',
      'masala dosa': 'img_masala_dosa', 'dosa': 'img_dosa', 'idli': 'img_idly', 'idly': 'img_idly',
      'vada': 'img_vada', 'puliyodharai': 'img_puliyodharai', 'sambar': 'img_samabar',
      'noodles': 'img_noodles', 'tacos': 'img_tacos', 'red sauce pasta': 'img_pasta',
      'vegetable stir fry': 'img_stirfry', 'carrot soup': 'img_carrotsoup',
    };
    final f = exact[n];
    return f == null ? null : 'assets/images/$f.png';
  }
}
