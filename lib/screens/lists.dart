import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../data/repo.dart';
import '../theme.dart';
import '../widgets/common.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});
  @override
  State<SavedScreen> createState() => _SavedState();
}

class _SavedState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final l = Repo.i.favRecipes;
    return AppPage(
      bottom: BottomNav(withSearch: true),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: EdgeInsets.all(14), child: BackDot()),
        Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text(t('Saved Recipes'), style: TextStyle(fontSize: 22))),
        Padding(padding: EdgeInsets.fromLTRB(20, 2, 20, 10), child: Text(t('Your favourite recipes, all in one place'), style: TextStyle(fontSize: 12))),
        Expanded(child: l.isEmpty ? Center(child: Text(t('No saved recipes yet')))
          : ListView(children: [for (final r in l)
              RecipeRow(r, () => startRecipe(context, r),
                trailing: GestureDetector(onTap: () async { await Repo.i.toggleFav(r); setState(() {}); }, child: Icon(Icons.favorite, color: Colors.red, size: 18)))])),
      ]),
    );
  }
}

class FavouritesScreen extends StatelessWidget {
  FavouritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = Repo.i.favRecipes;
    return AppPage(
      bottom: BottomNav(withSearch: true),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: EdgeInsets.fromLTRB(14, 20, 14, 10), child: Text(t('My Favourite Recipes'), style: TextStyle(fontSize: 22))),
        Container(margin: EdgeInsets.symmetric(horizontal: 14), height: 36, decoration: BoxDecoration(color: Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(18)),
            child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: 0.4,
                child: Container(decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(18)), alignment: Alignment.center,
                    child: Text(t('Recipes'), style: TextStyle(color: Colors.white, fontSize: 18))))),
        SizedBox(height: 8),
        Expanded(child: l.isEmpty ? Center(child: Text(t('No favourite recipes yet')))
          : ListView(children: [for (final r in l)
              GestureDetector(onTap: () => startRecipe(context, r), child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), color: Colors.white,
                child: Row(children: [
                  RecipeImage(r, w: 100, h: 82),
                  SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16)),
                    Row(children: [
                      if (r.rating != null) ...[Text(r.rating!.toStringAsFixed(1), style: TextStyle(fontSize: 16)), SizedBox(width: 4), Icon(Icons.star, color: Colors.green, size: 16), SizedBox(width: 12)],
                      Text(t(r.cuisine), style: TextStyle(fontSize: 11)),
                    ]),
                  ])),
                ]),
              ))])),
      ]),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Widget item(IconData i, String s0, VoidCallback f) => GestureDetector(onTap: f,
        child: Container(margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6), padding: EdgeInsets.all(18), color: Colors.white,
            child: Row(children: [Icon(i, color: Colors.black54), SizedBox(width: 20), Text(t(s0), style: TextStyle(fontSize: 15))])));
    return AppPage(
      bottom: BottomNav(withSearch: true),
      child: ListView(children: [
        SizedBox(height: 16),
        Padding(padding: EdgeInsets.all(14), child: Row(children: [
          Icon(Icons.account_circle_outlined, size: 70, color: Colors.black54), SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(Repo.i.userName ?? t('Guest'), style: TextStyle(fontSize: 20)), Text(t('View and edit profile'), style: TextStyle(fontSize: 11))])])),
        SizedBox(height: 20),
        item(Icons.language, 'Language', () => Navigator.pushNamed(context, '/language', arguments: {'fromProfile': true})),
        item(Icons.notifications_none, 'Notifications', () => Navigator.pushNamed(context, '/notifications')),
        item(Icons.set_meal_outlined, 'Dietary Preferences', () => Navigator.pushNamed(context, '/diet')),
        item(Icons.help_outline, 'Help & Support', () => Navigator.pushNamed(context, '/help')),
        item(Icons.info_outline, 'About Us', () => Navigator.pushNamed(context, '/about')),
        item(Icons.logout, 'Log Out', () => Navigator.pushNamed(context, '/logout')),
      ]),
    );
  }
}

class TradModernScreen extends StatelessWidget {
  TradModernScreen({super.key});
  Widget col(String img, String s0, List<String> pts) => Expanded(child: Container(margin: EdgeInsets.all(5), padding: EdgeInsets.all(8), color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Image.asset('assets/images/$img.png', height: 70)),
        SizedBox(height: 6), Text(t(s0), style: TextStyle(fontSize: 14)), SizedBox(height: 6),
        for (final p in pts) Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.check, size: 10, color: Colors.green), SizedBox(width: 3), Expanded(child: Text(t(p), style: TextStyle(fontSize: 9)))])),
      ])));
  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 14), child: Text(t('Traditional & Modern'), style: TextStyle(fontSize: 22))),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            col('method_traditional', 'Traditional\nMethod', ['Heavy-bottom vessel', 'Slow cooking', 'Dum cooking', 'Long preparation time', 'Uses traditional vessel']),
            col('method_modern', 'Modern\nMethod', ['Pressure Cooking', 'Fast cooking', 'Shorter cooking time', 'Less monitoring', 'Uses modern kitchen tools']),
          ]))),
          Spacer(),
          Center(child: Text(t('Both methods give delicious results!\nChoose based on your time & perference'), textAlign: TextAlign.center, style: TextStyle(fontSize: 14))),
          Spacer(),
          Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 24), child: RedButton('Continue', () => Navigator.pushNamed(context, '/people'), arrows: true)),
        ]),
      );
}
