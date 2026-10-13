import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../data/repo.dart';
import '../theme.dart';
import '../widgets/common.dart';

class LogoutScreen extends StatelessWidget {
  LogoutScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(14), child: BackDot())),
          Spacer(),
          CircleAvatar(radius: 36, backgroundColor: kRed, child: Icon(Icons.logout, color: Colors.white, size: 34)),
          SizedBox(height: 24),
          Text(t('Log Out ?'), style: TextStyle(fontSize: 26)),
          Padding(padding: EdgeInsets.all(16), child: Text(t('Are you sure you want to log out of CookWise?\nYour saved recipes will still be here when you come back.'),
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),
          Spacer(),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: RedButton('Yes, Log Out', () async {
            await Repo.i.logout();
            if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
          })),
          SizedBox(height: 14),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: RedButton('Cancel', () => Navigator.pop(context))),
          SizedBox(height: 40),
        ]),
      );
}

class DietScreen extends StatefulWidget {
  DietScreen({super.key});
  @override
  State<DietScreen> createState() => _DietState();
}

class _DietState extends State<DietScreen> {
  late final Set<String> sel = {...Repo.i.diet};
  static final hints = {
    'Vegetarian': 'No meat, poultry or fish',
    'Vegan': 'No meat, fish, dairy, eggs or honey',
    'Dairy-free': 'No milk, cheese, butter, curd or cream',
    'Egg-free': 'No eggs',
    'Nut-free': 'No peanuts or tree nuts',
  };
  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          BackPill('Dietary Preferences'),
          Padding(padding: EdgeInsets.fromLTRB(20, 14, 20, 8), child: Align(alignment: Alignment.centerLeft,
              child: Text(t('Choose what you eat. Recipes that do not match are hidden everywhere in the app.'), style: TextStyle(fontSize: 12)))),
          Expanded(child: ListView(children: [
            for (final d in Repo.dietOptions)
              GestureDetector(
                onTap: () => setState(() => sel.contains(d) ? sel.remove(d) : sel.add(d)),
                child: Container(margin: EdgeInsets.symmetric(horizontal: 14, vertical: 6), padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: sel.contains(d) ? Border.all(color: kRed) : null),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t(d), style: TextStyle(fontSize: 15)), Text(t(hints[d]!), style: TextStyle(fontSize: 11, color: Colors.black54))])),
                    Icon(sel.contains(d) ? Icons.check_box : Icons.check_box_outline_blank, color: sel.contains(d) ? kRed : Colors.black54),
                  ])),
              ),
            Padding(padding: EdgeInsets.all(16), child: Text(t('Based on ingredient names in the recipe data, so please double-check recipes for serious allergies.'), style: TextStyle(fontSize: 10, color: Colors.black54))),
          ])),
          Padding(padding: EdgeInsets.fromLTRB(40, 8, 40, 20), child: RedButton('Save', () async {
            await Repo.i.setDiet(sel);
            if (context.mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('Preferences saved')))); Navigator.pop(context); }
          })),
        ]),
      );
}
