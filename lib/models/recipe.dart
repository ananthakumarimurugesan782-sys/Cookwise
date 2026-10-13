import '../l10n/strings.dart';

class Ingredient {
  final String name, qty, unit, misc;
  Ingredient(this.name, this.qty, this.unit, this.misc);
  factory Ingredient.fromJson(Map j) =>
      Ingredient('${j['n'] ?? ''}', '${j['q'] ?? ''}', '${j['u'] ?? ''}', '${j['m'] ?? ''}');

  /// Parses "1", "1/2", "1 1/2", "0.5". Returns null if not numeric.
  double? get qtyValue {
    final s = qty.trim();
    if (s.isEmpty) return null;
    double total = 0;
    for (final p in s.split(RegExp(r'\s+'))) {
      if (p.contains('/')) {
        final f = p.split('/');
        final a = double.tryParse(f[0]), b = double.tryParse(f[1]);
        if (a == null || b == null || b == 0) return null;
        total += a / b;
      } else {
        final v = double.tryParse(p);
        if (v == null) return null;
        total += v;
      }
    }
    return total;
  }

  /// Quantity text scaled from [from] servings to [to] servings.
  String scaled(int from, int to) {
    final v = qtyValue;
    if (v == null) return qty.isEmpty ? '' : '$qty ${tUnit(unit)}'.trim();
    final r = v * to / from;
    final t = r == r.roundToDouble() ? r.toStringAsFixed(0) : r.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '');
    return '$t ${tUnit(unit)}'.trim();
  }
}

class Recipe {
  final int id, servings;
  final String name, cuisine;
  final List<String> category, steps, methods;
  final List<Ingredient> ingredients;
  final String url, region, image;
  final int? prep, cook;
  final double? rating;
  final Map<String, String> nutrition;

  Recipe({required this.id, required this.name, required this.cuisine, required this.category,
      required this.steps, required this.methods, required this.ingredients, required this.servings,
      this.prep, this.cook, this.rating, required this.nutrition, this.url = '', this.region = '', this.image = ''});

  factory Recipe.fromJson(Map j) => Recipe(
        id: j['id'],
        name: j['name'] ?? '',
        cuisine: j['cuisine'] ?? '',
        category: List<String>.from(j['category'] ?? []),
        steps: List<String>.from(j['steps'] ?? []),
        methods: List<String>.from(j['methods'] ?? []),
        ingredients: (j['ingredients'] as List? ?? []).map((e) => Ingredient.fromJson(e)).toList(),
        servings: j['servings'] ?? 1,
        url: j['url'] ?? '',
        region: j['region'] ?? '',
        image: j['image'] ?? '',
        prep: j['prep'],
        cook: j['cook'],
        rating: (j['rating'] as num?)?.toDouble(),
        nutrition: Map<String, String>.from((j['nutrition'] ?? {}).map((k, v) => MapEntry('$k', '$v'))),
      );

  int? get totalMins => (prep == null && cook == null) ? null : (prep ?? 0) + (cook ?? 0);
  String get timeText => totalMins == null ? '' : '${t('Time Taken')} : $totalMins ${t('mins')}';

  /// Numeric part of a nutrition value ("404 kcal" -> 404). Null if unavailable.
  double? nut(String key) {
    final v = nutrition[key];
    if (v == null) return null;
    return double.tryParse(RegExp(r'[\d.]+').firstMatch(v)?.group(0) ?? '');
  }
}
