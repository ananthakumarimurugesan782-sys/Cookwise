import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Set this to your real support address before release; the contact row stays hidden while empty.
final kSupportEmail = '';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotifState();
}

class _NotifState extends State<NotificationsScreen> {
  static final items = {
    'meal': ['Meal reminders', 'Remind me to cook at meal times'],
    'recipes': ['New recipes', 'Tell me when new recipes are added'],
    'shopping': ['Shopping list reminders', 'Remind me about items I still need to buy'],
  };
  final Map<String, bool> on = {};
  SharedPreferences? p;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((v) => setState(() {
          p = v;
          for (final k in items.keys) { on[k] = v.getBool('n_$k') ?? true; }
        }));
  }

  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          BackPill('Notifications'),
          Padding(padding: EdgeInsets.fromLTRB(20, 14, 20, 8), child: Align(alignment: Alignment.centerLeft,
              child: Text(t('Choose which reminders you would like.'), style: TextStyle(fontSize: 12)))),
          for (final e in items.entries)
            Container(margin: EdgeInsets.symmetric(horizontal: 14, vertical: 6), padding: EdgeInsets.fromLTRB(16, 8, 8, 8), color: Colors.white,
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t(e.value[0]), style: TextStyle(fontSize: 15)), Text(t(e.value[1]), style: TextStyle(fontSize: 11, color: Colors.black54))])),
                Switch(value: on[e.key] ?? true, activeColor: kRed, onChanged: (v) { setState(() => on[e.key] = v); p?.setBool('n_${e.key}', v); }),
              ])),
        ]),
      );
}

class HelpScreen extends StatelessWidget {
  HelpScreen({super.key});
  static final faq = [
    ['How do I cook with the ingredients I already have?', 'On Home, tap "Cook with my ingredients", add what you have (type it or pick a category) and tap a suggested recipe.'],
    ['How do I change the number of people?', 'After choosing a recipe you are asked how many people you are cooking for. Ingredient quantities are scaled from the recipe\'s original serving size.'],
    ['How do I save a recipe?', 'Finish cooking and tap "Save recipes" on the last screen. Saved recipes appear under "My favourite recipes".'],
    ['What is the shopping list?', 'It lists the ingredients you marked as "need to buy" for the recipe, so you know what to get before cooking.'],
    ['Why are some recipes missing?', 'Recipes that do not match your Dietary Preferences are hidden. Change them in Profile > Dietary Preferences.'],
    ['How do I change the language?', 'Go to Profile > Language and pick your preferred language.'],
  ];
  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          BackPill('Help & Support'),
          Expanded(child: ListView(padding: EdgeInsets.only(top: 10), children: [
            for (final f in faq)
              Container(margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5), color: Colors.white,
                child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(title: Text(t(f[0]), style: TextStyle(fontSize: 14)),
                    childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 14), expandedAlignment: Alignment.centerLeft,
                    children: [Text(t(f[1]), style: TextStyle(fontSize: 12))]))),
            if (kSupportEmail.isNotEmpty)
              Container(margin: EdgeInsets.all(14), padding: EdgeInsets.all(16), color: Colors.white,
                  child: Text('${t('Still need help? Email us at')} $kSupportEmail', style: TextStyle(fontSize: 13))),
          ])),
        ]),
      );
}

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          BackPill('About Us'),
          Expanded(child: ListView(padding: EdgeInsets.all(20), children: [
            Center(child: Image.asset('assets/images/chef_hat_red.png', height: 80)),
            SizedBox(height: 10),
            Center(child: Text(t('COOK WISE'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            Center(child: Text(t('Cook smart, eat better'), style: TextStyle(fontSize: 12))),
            SizedBox(height: 20),
            Text(t('CookWise helps you discover recipes from different cuisines, cook with the ingredients you already have, and understand exactly what to buy and how much to use.'), style: TextStyle(fontSize: 14, height: 1.4)),
            SizedBox(height: 16),
            for (final s0 in ['Multicuisine recipes with step-by-step instructions', 'Cook with my ingredients', 'Quantities adjusted for the number of people', 'Nutrition information per serving', 'Traditional and modern cooking methods', 'Save favourite recipes and plan your shopping list'])
              Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.check, color: kRed, size: 16), SizedBox(width: 8), Expanded(child: Text(t(s0), style: TextStyle(fontSize: 13)))])),
            SizedBox(height: 20),
            Center(child: Text(t('Version 1.0.0'), style: TextStyle(fontSize: 11, color: Colors.black54))),
          ])),
        ]),
      );
}
