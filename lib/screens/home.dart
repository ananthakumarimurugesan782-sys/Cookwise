import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../data/repo.dart';
import '../models/recipe.dart';
import '../theme.dart';
import '../widgets/common.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  Recipe? find(String k, {String? cuisine}) {
    final l = Repo.i.visible.where((r) => r.name.toLowerCase().contains(k) && (cuisine == null || r.cuisine == cuisine));
    return l.isEmpty ? null : l.first;
  }

  Widget tile(BuildContext c, String img, String label, String route, {IconData? icon}) => Expanded(
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(c, route),
          child: Container(
            height: 108, margin: EdgeInsets.all(5), padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              img.isEmpty ? Icon(icon, size: 36, color: kRed) : Image.asset('assets/images/$img.png', height: 40),
              Spacer(),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(child: Text(t(label), style: TextStyle(fontSize: 14))),
                CircleAvatar(radius: 9, backgroundColor: Colors.black, child: Icon(Icons.arrow_forward_ios, size: 9, color: Colors.white)),
              ]),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final sugg = [find('vegetable biryani'), find('pasta', cuisine: 'Italian'), find('taco')].whereType<Recipe>().toList();
    final more = Repo.i.visible.where((r) => !sugg.contains(r)).skip(7).take(3);
    sugg.addAll(more);
    return AppPage(
      bottom: BottomNav(),
      child: ListView(padding: EdgeInsets.all(12), children: [
        Text(t('HELLO !....👋\nwhat would you like to cook today ?...'), style: TextStyle(fontSize: 14)),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/cuisine_list', arguments: {'focus': true}),
          child: Container(padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black12)),
              child: Row(children: [Icon(Icons.search, color: Colors.black54), SizedBox(width: 8), Text(t('Search for a dish'), style: TextStyle(color: Colors.black54))])),
        ),
        Row(children: [tile(context, 'icon_explore', 'Explore more cuisines', '/cuisines'), tile(context, 'icon_ingredients', 'Cook with my ingredients', '/cook_with')]),
        Row(children: [tile(context, 'icon_cart', 'Shopping', '/shopping'), tile(context, 'icon_heart', 'My favourite recipes', '/favourites')]),
        SizedBox(height: 26),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(t('SUGGESETIONS'), style: TextStyle(fontSize: 13)),
          GestureDetector(onTap: () => Navigator.pushNamed(context, '/cuisine_list'), child: Text(t('See All'), style: TextStyle(fontSize: 13))),
        ]),
        SizedBox(height: 8),
        SizedBox(height: 120, child: ListView(scrollDirection: Axis.horizontal, children: [
          for (final r in sugg)
            GestureDetector(onTap: () => startRecipe(context, r), child: Container(width: 120, margin: EdgeInsets.only(right: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RecipeImage(r, w: 120, h: 80, preferAsset: true),
                Text(r.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                Text(t(r.cuisine), style: TextStyle(fontSize: 10)),
              ]))),
        ])),
      ]),
    );
  }
}

class CuisinesScreen extends StatelessWidget {
  CuisinesScreen({super.key});
  static final items = ['Indian', 'Italian', 'Chinese', 'Mexican', 'Japanese', 'Korean'];
  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          BackPill('Choose Your Cuisine'),
          Padding(padding: EdgeInsets.fromLTRB(20, 16, 12, 24), child: Align(alignment: Alignment.centerLeft, child: Text(t('Exlpore more recipes around the world.....'), style: TextStyle(fontSize: 13)))),
          Expanded(child: GridView.count(crossAxisCount: 2, mainAxisSpacing: 24, crossAxisSpacing: 40, padding: EdgeInsets.symmetric(horizontal: 30),
            childAspectRatio: 1.45, children: [
              for (final c in items)
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/cuisine_list', arguments: {'cuisine': c}),
                  child: Container(color: Colors.white.withOpacity(0.6), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Image.asset('assets/images/cuisine_${c.toLowerCase()}.png', height: 55, errorBuilder: (_, __, ___) => Icon(Icons.restaurant)),
                    SizedBox(height: 6), Text(t(c), style: TextStyle(fontSize: 13)),
                  ])),
                ),
            ])),
        ]),
      );
}

class CuisineListScreen extends StatefulWidget {
  CuisineListScreen({super.key});
  @override
  State<CuisineListScreen> createState() => _CuisineListScreenState();
}

class _CuisineListScreenState extends State<CuisineListScreen> {
  String q = '';
  int tab = 1; // 0 North, 1 South, 2 Others (Indian only)
  String? cuisine;
  bool init = false;
  static final south = ['dosa', 'idli', 'idly', 'vada', 'sambar', 'sambhar', 'uttapam', 'rasam', 'upma', 'puliyodharai', 'avial', 'poriyal', 'kerala', 'chettinad', 'coconut'];
  static final north = ['paneer', 'naan', 'paratha', 'tikka', 'saag', 'palak', 'chole', 'rajma', 'punjabi', 'tandoori', 'butter', 'korma', 'aloo', 'samosa', 'dal makhani'];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!init) {
      final a = ModalRoute.of(context)?.settings.arguments;
      if (a is Map) cuisine = a['cuisine'];
      init = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var list = Repo.i.search(q, cuisine: cuisine);
    if (cuisine == 'Indian') {
      bool has(Recipe r, List<String> k) => k.any((x) => r.name.toLowerCase().contains(x));
      list = list.where((r) => tab == 1 ? (r.region == 'South Indian' || (r.region.isEmpty && has(r, south))) : tab == 0 ? (r.region == 'North Indian' || (r.region.isEmpty && has(r, north) && !has(r, south))) : (r.region == 'Other' || (r.region.isEmpty && !has(r, south) && !has(r, north)))).toList();
    }
    Widget chip(String s0, int i) => Expanded(child: GestureDetector(onTap: () => setState(() => tab = i),
        child: Container(margin: EdgeInsets.symmetric(horizontal: 6), padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(color: tab == i ? kRed : Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(t(s0), style: TextStyle(fontSize: 10, color: tab == i ? Colors.white : Colors.black))))));
    return AppPage(
      bottom: cuisine == null ? BottomNav(withSearch: true) : null,
      child: Column(children: [
        BackPill(cuisine == null ? 'Search' : tf('{c} Cuisine', {'c': t(cuisine!)})),
        Container(margin: EdgeInsets.all(12), padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
            child: TextField(onChanged: (v) => setState(() => q = v), decoration: InputDecoration(border: InputBorder.none, hintText: t('Search for a dish'), prefixIcon: Icon(Icons.search)))),
        if (cuisine == 'Indian') Row(children: [chip('North Indian', 0), chip('South Indian', 1), chip('Others', 2)]),
        Expanded(child: list.isEmpty
            ? Center(child: Text(t('No recipes found')))
            : ListView.builder(itemCount: list.length > 200 ? 200 : list.length, itemBuilder: (_, i) => RecipeRow(list[i], () => startRecipe(context, list[i])))),
      ]),
    );
  }
}

class CookWithIngredientsScreen extends StatefulWidget {
  CookWithIngredientsScreen({super.key});
  @override
  State<CookWithIngredientsScreen> createState() => _CookWithState();
}

class _CookWithState extends State<CookWithIngredientsScreen> {
  final have = <String>{};
  final ctl = TextEditingController();
  static final cats = {
    'vegetables': ['tomato', 'onion', 'carrot', 'potato', 'spinach', 'cabbage', 'cauliflower', 'peas'],
    'Grains & cereals': ['rice', 'flour', 'oats', 'pasta', 'bread'],
    'Meat & Seafood': ['chicken', 'beef', 'pork', 'shrimp', 'fish', 'lamb'],
    'Dairy & Milk': ['milk', 'butter', 'cheese', 'yogurt', 'cream', 'paneer'],
    'Spices & Herbs': ['cumin', 'turmeric', 'cilantro', 'basil', 'garlic', 'ginger', 'chili'],
    'Fruits': ['apple', 'lemon', 'banana', 'mango', 'lime', 'orange'],
    'Pantry Staples': ['salt', 'sugar', 'oil', 'egg', 'beans', 'lentils'],
  };
  String? openCat;
  void add(String s) {
    final v = s.trim().toLowerCase();
    if (v.isNotEmpty) setState(() => have.add(v));
    ctl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final matches = have.isEmpty ? <MapEntry<Recipe, int>>[] : Repo.i.matchIngredients(have).take(30).toList();
    return AppPage(
      child: ListView(children: [
        BackPill('Cook with My Ingredients'),
        Padding(padding: EdgeInsets.all(14), child: Text(t('Enter the ingredients you have , we will suggest\ndelicious recipes you can cook'), style: TextStyle(fontSize: 12))),
        Container(margin: EdgeInsets.symmetric(horizontal: 12), padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: TextField(controller: ctl, onSubmitted: add, decoration: InputDecoration(border: InputBorder.none, hintText: t('Search for an ingredient'), prefixIcon: Icon(Icons.search)))),
        Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(t('Your Ingredients')),
          GestureDetector(onTap: () => setState(have.clear), child: Text(t('clear all'), style: TextStyle(fontSize: 11, color: Colors.black38))),
        ])),
        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Wrap(spacing: 8, children: [
          for (final h in have) InputChip(label: Text(h, style: TextStyle(fontSize: 12)), avatar: Icon(Icons.close, size: 12),
              backgroundColor: Colors.white, onPressed: () => setState(() => have.remove(h))),
        ])),
        Padding(padding: EdgeInsets.fromLTRB(16, 14, 16, 6), child: Text(t('Or choose from categories'), style: TextStyle(fontSize: 12))),
        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Wrap(spacing: 8, runSpacing: 8, children: [
          for (final c in cats.keys)
            GestureDetector(onTap: () => setState(() => openCat = openCat == c ? null : c),
                child: Container(width: 76, height: 50, alignment: Alignment.center, padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Color(0xFFBFE6F5), borderRadius: BorderRadius.circular(6), border: openCat == c ? Border.all(color: kRed) : null),
                    child: Text(t(c), textAlign: TextAlign.center, style: TextStyle(fontSize: 10)))),
        ])),
        if (openCat != null) Padding(padding: EdgeInsets.all(12), child: Wrap(spacing: 8, children: [
          for (final i in cats[openCat]!) ActionChip(label: Text(t(i), style: TextStyle(fontSize: 12)), backgroundColor: have.contains(i) ? Color(0xFFFFC9C9) : Colors.white, onPressed: () => setState(() => have.contains(i) ? have.remove(i) : have.add(i))),
        ])),
        Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text(t('Recipes for you'), style: TextStyle(fontSize: 13))),
        if (have.isEmpty) Padding(padding: EdgeInsets.all(16), child: Text(t('Add ingredients to see suggestions'), style: TextStyle(fontSize: 12, color: Colors.black45))),
        for (final m in matches)
          RecipeRow(m.key, () { Repo.i.haveAtHome..clear()..addAll(have); startRecipe(context, m.key); },
              trailing: Text(tf('Uses {n} ingredients', {'n': '${m.value}'}), style: TextStyle(fontSize: 10))),
      ]),
    );
  }
}
