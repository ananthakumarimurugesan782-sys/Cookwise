import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/recipe.dart';

/// Approximate market prices (Rs) from assets/data/prices.json - vegetables and meat only.
/// Prices change daily; edit prices.json (or refresh it from an API later) to update them.
class PriceBook {
  PriceBook._();
  static final PriceBook i = PriceBook._();
  List<Map<String, dynamic>> _items = [];
  String vegDate = '', meatDate = '';

  Future<void> load() async {
    final j = jsonDecode(await rootBundle.loadString('assets/data/prices.json'));
    _items = List<Map<String, dynamic>>.from(j['items']);
    vegDate = j['asOf_veg'] ?? '';
    meatDate = j['asOf_meat'] ?? '';
  }

  static const _skipUnits = {'green', 'dried', 'canned', 'frozen', 'sweet', 'smoked', 'cooking', 'ground'};
  static const _size = {'small': 0.7, 'medium': 1.0, 'large': 1.3};

  Map<String, dynamic>? _find(String name) {
    final n = name.toLowerCase().replaceAll(RegExp(r'\([^)]*\)'), '').replaceAll(RegExp(r'\s+'), ' ').trim();
    for (final e in _items) {
      if (RegExp(e['re']).hasMatch(n)) return e;
    }
    return null;
  }

  /// Price for an ingredient already scaled to [qty]. Returns null when no price is known.
  double? price(Ingredient ing, double? qty) {
    if (qty == null) return null;
    final e = _find(ing.name);
    if (e == null) return null;
    final u = ing.unit.toLowerCase().trim();
    if (_skipUnits.contains(u)) return null;
    final per = e['per'] as String;
    final p = (e['price'] as num).toDouble();
    double? n(String k, double d) => (e[k] as num?)?.toDouble() ?? d;
    double? grams;
    double? count;
    if (u == 'g' || u == 'gram' || u == 'grams') {
      grams = qty;
    } else if (u == 'kg') {
      grams = qty * 1000;
    } else if (u == 'ounce' || u == 'ounces' || u == 'oz') {
      grams = qty * 28.35;
    } else if (u == 'pound' || u == 'pounds' || u == 'lb' || u == 'lbs') {
      grams = qty * 453.6;
    } else if (u == 'cup' || u == 'cups') {
      grams = qty * n('cupG', 150)!;
    } else if (u == 'tablespoon' || u == 'tablespoons') {
      grams = qty * n('tbspG', 15)!;
    } else if (u == 'teaspoon' || u == 'teaspoons') {
      grams = qty * n('tspG', 5)!;
    } else if (u == 'clove' || u == 'cloves') {
      grams = qty * n('pieceG', 5)!;
    } else if (u == 'inch' || u == 'inches') {
      grams = qty * 8;
    } else if (u == 'sprig' || u == 'sprigs') {
      grams = qty * 2;
    } else if (u == 'bunch') {
      if (per == 'bunch') return p * qty;
      return null;
    } else if (const {'pinch', 'dash', 'container', 'jar', 'quart', 'slices', 'cube'}.contains(u)) {
      return null;
    } else {
      // count-style units: '', large, medium, small, whole, piece, head, roma...
      count = qty * (_size[u] ?? 1.0);
    }
    if (per == 'piece') {
      return p * (count ?? grams! / n('pieceG', 400)!);
    }
    grams ??= count! * n('pieceG', 100)!;
    if (per == 'bunch') return p * grams / n('bunchG', 50)!;
    return grams / 1000 * p;
  }

  /// Two table cells ("1 kg", "1/2 kg") for an ingredient, or null when no price is known.
  List<String>? kgCells(Ingredient ing) {
    final e = _find(ing.name);
    if (e == null) return null;
    final p = (e['price'] as num).toDouble();
    String f(double v) => '\u20B9${v == v.roundToDouble() ? v.round() : v.toStringAsFixed(1)}';
    switch (e['per']) {
      case 'bunch': return ['${f(p)}/bunch', '-'];
      case 'piece': return ['${f(p)}/piece', '-'];
      case 'litre': return ['${f(p)}/L', '${f(p / 2)}/\u00BDL'];
      default: return [f(p), f(p / 2)];
    }
  }

  bool isMeat(String name) => RegExp(r'chicken|lamb|mutton|goat|fish|snapper|prawn|shrimp|crab|squid|calamari|tilapia|cod').hasMatch(name.toLowerCase());
}
