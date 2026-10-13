import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../data/repo.dart';
import '../models/recipe.dart';
import '../data/prices.dart';
import '../theme.dart';
import '../widgets/ing_icon.dart';
import '../widgets/tr_name.dart';
import '../data/translate.dart';
import '../widgets/common.dart';

Recipe get _r => Repo.i.current!;

class PeopleScreen extends StatefulWidget {
  PeopleScreen({super.key});
  @override
  State<PeopleScreen> createState() => _PeopleState();
}

class _PeopleState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(14), child: BackDot())),
          Spacer(),
          CircleAvatar(radius: 36, backgroundColor: kRed, child: Icon(Icons.people_alt_outlined, color: Colors.black, size: 38)),
          SizedBox(height: 24),
          Text(t('How many  People  are you cooking  for ?'), style: TextStyle(fontSize: 15)),
          SizedBox(height: 24),
          Container(width: 215, height: 58, decoration: BoxDecoration(color: Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Expanded(child: IconButton(icon: Icon(Icons.remove, size: 30), onPressed: () => setState(() => Repo.i.people = max(1, Repo.i.people - 1)))),
              Container(width: 100, height: 58, color: Colors.grey, alignment: Alignment.center, child: Text('${Repo.i.people}', style: TextStyle(fontSize: 30))),
              Expanded(child: IconButton(icon: Icon(Icons.add, size: 30), onPressed: () => setState(() => Repo.i.people = min(50, Repo.i.people + 1)))),
            ])),
          SizedBox(height: 24),
          Text(t('This will adjust the quantites of ingredients\nautomatically.'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF4A5080))),
          Spacer(),
          Padding(padding: EdgeInsets.fromLTRB(70, 0, 70, 20), child: RedButton('Continue', () => Navigator.pushNamed(context, '/method'), arrows: true)),
        ]),
      );
}

class MethodScreen extends StatefulWidget {
  MethodScreen({super.key});
  @override
  State<MethodScreen> createState() => _MethodState();
}

class _MethodState extends State<MethodScreen> {
  int? sel;
  Widget card(String img, String? title, String sub, int i) => GestureDetector(
        onTap: () => setState(() => sel = i),
        child: Container(margin: EdgeInsets.fromLTRB(14, 8, 14, 8), padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Image.asset('assets/images/$img.png', width: 90, height: 100),
              Expanded(child: Padding(padding: EdgeInsets.only(left: 20), child: Text(t(title ?? ''), style: TextStyle(fontSize: 14)))),
              Icon(sel == i ? Icons.radio_button_checked : Icons.radio_button_unchecked, size: 20),
            ]),
            SizedBox(height: 8), Text(sub, style: TextStyle(fontSize: 12)),
          ])),
      );
  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          BackPill('Choose cooking method'),
          Padding(padding: EdgeInsets.fromLTRB(20, 14, 20, 8), child: Align(alignment: Alignment.centerLeft,
              child: Text(tf('Select your preferred method for cooking {name}', {'name': _r.name.toLowerCase()}), style: TextStyle(fontSize: 12)))),
          card('method_traditional', 'Traditional  Method', 'Slow cooking in a traditional pot for\nauthentic taste', 0),
          card('method_modern', 'Modern Method', 'Use pressure cooker / model appliance for faster\npreparation method', 1),
          Spacer(),
          Padding(padding: EdgeInsets.fromLTRB(60, 0, 60, 20), child: RedButton('View cooking instruction', () {
            if (sel == null) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('Please choose a method')))); return; }
            Repo.i.modern = sel == 1;
            Navigator.pushNamed(context, '/ingredients');
          }, arrows: true)),
        ]),
      );
}

/// "Ingredients for N People" - quantities scaled from the dataset's serving size.
class IngredientsScreen extends StatelessWidget {
  IngredientsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final r = _r;
    final n = Repo.i.people;
    return AppPage(
      child: Column(children: [
        BackPill(tf('Ingredients for {n} People', {'n': '$n'})),
        Padding(padding: EdgeInsets.all(14), child: Align(alignment: Alignment.centerLeft,
            child: Text(tf('Here are the required ingredients for {name}', {'name': r.name.toLowerCase()}), style: TextStyle(fontSize: 12)))),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(onTap: () => Navigator.pushNamed(context, '/availability'), child: _pill('At Home', Icons.home)),
          GestureDetector(onTap: () => Navigator.pushNamed(context, '/shopping'), child: _pill('Need to buy', Icons.shopping_cart)),
        ])),
        SizedBox(height: 10),
        Expanded(child: r.ingredients.isEmpty ? Center(child: Text(t('No ingredient list available')))
          : ListView(children: [
            for (final i in r.ingredients)
              StatefulBuilder(builder: (c, set) {
                final home = Repo.i.haveAtHome.any((h) => i.name.toLowerCase().contains(h.toLowerCase()));
                return GestureDetector(
                  onTap: () => set(() { home ? Repo.i.haveAtHome.removeWhere((h) => i.name.toLowerCase().contains(h.toLowerCase())) : Repo.i.haveAtHome.add(i.name.toLowerCase()); }),
                  child: Container(margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5), padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      Expanded(flex: 3, child: Row(children: [IngIcon(i.name), SizedBox(width: 8), Expanded(child: TrName(i.name, style: TextStyle(fontSize: 13)))])),
                      Expanded(flex: 2, child: Text(i.scaled(r.servings, n), style: TextStyle(fontSize: 12))),
                      Icon(home ? Icons.check_circle : Icons.shopping_cart, size: 18),
                    ])),
                );
              }),
          ])),
        Padding(padding: EdgeInsets.fromLTRB(80, 8, 80, 16), child: RedButton('Continue', () => Navigator.pushNamed(context, '/allset'), arrows: true)),
      ]),
    );
  }

  static Widget _pill(String s0, IconData i) => Container(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [Text(t(s0), style: TextStyle(fontSize: 12)), SizedBox(width: 10), Icon(i, size: 15)]));
}

class AvailabilityScreen extends StatefulWidget {
  AvailabilityScreen({super.key});
  @override
  State<AvailabilityScreen> createState() => _AvailState();
}

class _AvailState extends State<AvailabilityScreen> {
  @override
  Widget build(BuildContext context) {
    final r = _r;
    final n = Repo.i.people;
    return AppPage(
      child: Column(children: [
        Padding(padding: EdgeInsets.all(14), child: Row(children: [BackDot(), SizedBox(width: 12), Text(t('Ingredient Availability check'), style: TextStyle(fontSize: 20))])),
        Container(margin: EdgeInsets.symmetric(horizontal: 12), padding: EdgeInsets.all(12), color: Colors.white,
          child: Row(children: [Expanded(flex: 3, child: Text(t('Item'))), Expanded(flex: 2, child: Text(t('At home'))), Expanded(flex: 2, child: Text(t('Need to buy')))])),
        Expanded(child: ListView(children: [
          for (final i in r.ingredients)
            Builder(builder: (c) {
              final home = Repo.i.haveAtHome.any((h) => i.name.toLowerCase().contains(h.toLowerCase()));
              final q = i.scaled(r.servings, n);
              return GestureDetector(
                onTap: () => setState(() { home ? Repo.i.haveAtHome.removeWhere((h) => i.name.toLowerCase().contains(h.toLowerCase())) : Repo.i.haveAtHome.add(i.name.toLowerCase()); }),
                child: Container(margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5), padding: EdgeInsets.all(12), color: Colors.white,
                  child: Row(children: [
                    Expanded(flex: 3, child: Row(children: [IngIcon(i.name), SizedBox(width: 8), Expanded(child: TrName(i.name, style: TextStyle(fontSize: 12)))])),
                    Expanded(flex: 2, child: Text(home ? q : '-', style: TextStyle(fontSize: 12))),
                    Expanded(flex: 2, child: Text(home ? '-' : q, style: TextStyle(fontSize: 12))),
                  ])),
              );
            }),
        ])),
        Padding(padding: EdgeInsets.fromLTRB(40, 8, 40, 16), child: RedButton('Update', () => Navigator.pop(context))),
      ]),
    );
  }
}

/// Shopping list: ingredients needed (not at home). The dataset has no prices,
/// so price is shown as "-" rather than invented.
class ShoppingScreen extends StatelessWidget {
  ShoppingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final r = Repo.i.current;
    final n = Repo.i.people;
    final items = r == null ? <Ingredient>[] : r.ingredients.where((i) => !Repo.i.haveAtHome.any((h) => i.name.toLowerCase().contains(h.toLowerCase()))).toList();
    final prices = <Ingredient, double?>{
      for (final i in items) i: PriceBook.i.price(i, i.qtyValue == null ? null : i.qtyValue! * n / r!.servings)
    };
    final total = prices.values.whereType<double>().fold<double>(0, (a, b) => a + b);
    return AppPage(
      bottom: BottomNav(),
      child: Column(children: [
        Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 8), child: Align(alignment: Alignment.centerLeft,
            child: Text(t('Shopping List\nItems you need to buy and their approximate\nmarket price'), style: TextStyle(fontSize: 14)))),
        Container(margin: EdgeInsets.symmetric(horizontal: 12), padding: EdgeInsets.all(10), color: Color(0xFFBFE6F5),
            child: Row(children: [Expanded(flex: 3, child: Text(t('Item'))), Expanded(flex: 2, child: Text(t('Qty to buy'), style: TextStyle(fontSize: 12))),
              Expanded(flex: 2, child: Text(t('1 kg'), style: TextStyle(fontSize: 12))), Expanded(flex: 2, child: Text(t('\u00BD kg'), style: TextStyle(fontSize: 12)))])),
        Expanded(child: items.isEmpty ? Center(child: Text(t('Your shopping list is empty')))
          : ListView(children: [
            for (final i in items)
              Container(margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4), padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black12)),
                child: Row(children: [
                  Expanded(flex: 3, child: Row(children: [IngIcon(i.name), SizedBox(width: 8), Expanded(child: TrName(i.name, style: TextStyle(fontSize: 12)))])),
                  Expanded(flex: 2, child: Text(i.scaled(r!.servings, n), style: TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text(PriceBook.i.kgCells(i)?[0] ?? '-', style: TextStyle(fontSize: 11))),
                  Expanded(flex: 2, child: Text(PriceBook.i.kgCells(i)?[1] ?? '-', style: TextStyle(fontSize: 11))),
                ])),
          ])),
        Container(margin: EdgeInsets.fromLTRB(12, 8, 12, 8), padding: EdgeInsets.all(10), width: double.infinity, color: Colors.white,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t('Estimated Total'), style: TextStyle(fontSize: 16)),
              Text(total == 0 ? '-' : '₹${total.round()}', style: TextStyle(fontSize: 26)),
              Text(t('(Approximate market price)'), style: TextStyle(fontSize: 10)),
            ])),
        Padding(padding: EdgeInsets.fromLTRB(12, 0, 12, 12), child: RedButton('Add to Shopping List', () =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tf('{n} items in your shopping list', {'n': '${items.length}'})))), icon: Icons.shopping_cart_outlined)),
      ]),
    );
  }
}

class AllSetScreen extends StatelessWidget {
  AllSetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final r = _r;
    final cal = r.nutrition['Calories'];
    Widget row(IconData i, String s0) => Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Row(children: [Icon(i, color: kRed, size: 16), SizedBox(width: 10), Text(s0, style: TextStyle(fontSize: 11))]));
    return AppPage(
      child: Column(children: [
        Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(14), child: BackDot())),
        SizedBox(height: 20),
        CircleAvatar(radius: 15, backgroundColor: kRed, child: Icon(Icons.check, color: Colors.white, size: 18)),
        SizedBox(height: 6),
        Text(t('All Set !'), style: TextStyle(fontSize: 26)),
        Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text(tf('Your {name} is ready to cook', {'name': r.name.toLowerCase()}), textAlign: TextAlign.center, style: TextStyle(fontSize: 11))),
        Spacer(),
        Container(margin: EdgeInsets.symmetric(horizontal: 30), padding: EdgeInsets.all(14), width: double.infinity, color: Colors.white,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${t('Method')} : ${t(Repo.i.modern ? 'Modern' : 'Traditional')}', style: TextStyle(fontSize: 11)),
            row(Icons.people, '${t('Servings')} : ${Repo.i.people}'),
            if (r.totalMins != null) row(Icons.timer, '${t('Cooking time')} : ${r.totalMins} ${t('mins')}'),
            if (cal != null) row(Icons.local_fire_department, '${t('Calories (per serving)')} : $cal'),
          ])),
        Spacer(),
        Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 20), child: RedButton('Start cooking', () => Navigator.pushNamed(context, '/steps'))),
      ]),
    );
  }
}

class StepsScreen extends StatefulWidget {
  StepsScreen({super.key});
  @override
  State<StepsScreen> createState() => _StepsState();
}

class _StepsState extends State<StepsScreen> {
  int i = 0;
  late List<String> steps = _r.steps;
  @override
  void initState() {
    super.initState();
    if (Translate.i.enabled) {
      Translate.i.many(_r.steps).then((v) { if (mounted) setState(() => steps = v); });
    }
  }
  @override
  Widget build(BuildContext context) {
    final r = _r;
    final total = steps.length;
    if (total == 0) return AppPage(child: Center(child: Text(t('No cooking steps available'))));
    return AppPage(
      child: Padding(padding: EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [BackDot(), SizedBox(width: 12), Expanded(child: Text('${r.name}\n(${t(Repo.i.modern ? 'Modern Method' : 'Traditional Method')})', style: TextStyle(fontSize: 16)))]),
        SizedBox(height: 16),
        Text(tf('Steps {a} of {b}', {'a': '${i + 1}', 'b': '$total'}), style: TextStyle(fontSize: 11)),
        SizedBox(height: 4),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: (i + 1) / total, minHeight: 6, color: kRed, backgroundColor: Color(0xFFE0E0E0))),
        SizedBox(height: 20),
        SizedBox(height: 4),
        Text(tf('Step {a}', {'a': '${i + 1}'}), style: TextStyle(fontSize: 26)),
        SizedBox(height: 8),
        Expanded(child: SingleChildScrollView(child: Text(steps[i], style: TextStyle(fontSize: 16, height: 1.45)))),
        Center(child: TextButton(onPressed: () => showModalBottomSheet(context: context, backgroundColor: kBg, isScrollControlled: true,
            builder: (_) => DraggableScrollableSheet(expand: false, initialChildSize: 0.8, builder: (c, sc) => ListView(controller: sc, padding: EdgeInsets.all(16), children: [
              Text('${t('All steps')} - ${r.name}', style: TextStyle(fontSize: 18)), SizedBox(height: 10),
              for (var k = 0; k < total; k++) Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Text('${k + 1}. ${steps[k]}', style: TextStyle(fontSize: 14, color: k == i ? kRed : Colors.black))),
            ]))), child: Text(t('View all steps'), style: TextStyle(color: kRed)))),
        Row(children: [
          Expanded(child: RedButton('Previous', () { if (i > 0) setState(() => i--); })),
          SizedBox(width: 12),
          Expanded(child: RedButton(i == total - 1 ? 'Finish' : 'Next', () { i == total - 1 ? Navigator.pushNamed(context, '/nutrition') : setState(() => i++); }, arrows: true)),
        ]),
      ])),
    );
  }
}

class _Ring extends CustomPainter {
  final double frac;
  _Ring(this.frac);
  @override
  void paint(Canvas c, Size s) {
    final rect = Offset.zero & s;
    final p = Paint()..style = PaintingStyle.stroke..strokeWidth = 8;
    c.drawArc(rect.deflate(4), 0, 2 * pi, false, p..color = Color(0xFFFFC9C9));
    c.drawArc(rect.deflate(4), -pi / 2, 2 * pi * frac, false, p..color = kRed);
  }
  @override
  bool shouldRepaint(_) => true;
}

class NutritionScreen extends StatelessWidget {
  NutritionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final r = _r;
    final cal = r.nut('Calories');
    Widget kv(String k, String key) => Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(t(k), style: TextStyle(fontSize: 12)), Text(r.nutrition[key]?.replaceAll(' ', '') ?? t('N/A'), style: TextStyle(fontSize: 12))]));
    final carbs = r.nut('Carbohydrates') ?? 0, fat = r.nut('Fat') ?? 0, pro = r.nut('Protein') ?? 0, fib = r.nut('Fiber') ?? 0;
    final tot = carbs + fat + pro + fib;
    String pct(double v) => tot == 0 ? t('N/A') : '${(v / tot * 100).round()}%';
    return AppPage(
      child: ListView(padding: EdgeInsets.all(12), children: [
        Row(children: [BackDot(), SizedBox(width: 12), Text(t('Nutritional Information'), style: TextStyle(fontSize: 16))]),
        Padding(padding: EdgeInsets.fromLTRB(4, 14, 4, 8), child: Text(t('For 1 serving'), style: TextStyle(fontSize: 12))),
        Container(padding: EdgeInsets.all(12), color: Colors.white, child: Row(children: [
          SizedBox(width: 80, height: 80, child: CustomPaint(painter: _Ring(cal == null ? 0 : min(1, cal / 2000)), child: Center(child: Text(cal == null ? t('N/A') : '${cal.round()}\n${t('Kcal')}', textAlign: TextAlign.center)))),
          SizedBox(width: 30),
          Expanded(child: Column(children: [kv('Protein', 'Protein'), kv('carbohydrate', 'Carbohydrates'), kv('Fat', 'Fat'), kv('Fiber', 'Fiber')])),
        ])),
        SizedBox(height: 20),
        Container(padding: EdgeInsets.all(12), color: Colors.white, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t('Nutrition Breakdown'), style: TextStyle(fontSize: 12)),
          Row(children: [
            SizedBox(width: 80, height: 80, child: CustomPaint(painter: _Ring(tot == 0 ? 0 : carbs / tot))),
            SizedBox(width: 30),
            Expanded(child: Column(children: [
              _line('carbs', pct(carbs)), _line('Fat', pct(fat)), _line('Protein', pct(pro)), _line('Fibre', pct(fib))])),
          ]),
          Text(t('*values are approximate and may vary based on ingredients and portion size'), style: TextStyle(fontSize: 8)),
        ])),
        SizedBox(height: 30),
        Padding(padding: EdgeInsets.symmetric(horizontal: 90), child: RedButton('Continue', () => Navigator.pushNamed(context, '/enjoy'), arrows: true)),
      ]),
    );
  }

  Widget _line(String k, String v) => Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t(k), style: TextStyle(fontSize: 12)), Text(v, style: TextStyle(fontSize: 12))]));
}

class EnjoyScreen extends StatefulWidget {
  EnjoyScreen({super.key});
  @override
  State<EnjoyScreen> createState() => _EnjoyState();
}

class _EnjoyState extends State<EnjoyScreen> with SingleTickerProviderStateMixin {
  late final AnimationController ac = AnimationController(vsync: this, duration: Duration(milliseconds: 2800))..forward();
  @override
  void dispose() { ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AppPage(
        // LayoutBuilder: everything is sized from the available width/height, so it fits phones and Windows windows
        child: LayoutBuilder(builder: (context, box) {
          final w = box.maxWidth, h = box.maxHeight;
          final hat = (w * 0.42).clamp(90.0, 190.0);
          final big = (w * 0.075).clamp(22.0, 34.0);
          return Stack(children: [
            Positioned.fill(child: AnimatedBuilder(animation: ac, builder: (_, __) => CustomPaint(painter: _Confetti(ac.value)))),
            Column(children: [
              Spacer(flex: 2),
              Image.asset('assets/images/enjoy_meal.png', width: hat * 1.7, height: hat, fit: BoxFit.contain),
              SizedBox(height: h * 0.03),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text(t('Enjoy your meal !'), textAlign: TextAlign.center, style: TextStyle(fontSize: big))),
              SizedBox(height: h * 0.015),
              Text(t('Healthy food . Happier you'), textAlign: TextAlign.center, style: TextStyle(fontSize: (w * 0.035).clamp(12.0, 16.0))),
              Spacer(flex: 3),
              Padding(padding: EdgeInsets.symmetric(horizontal: w * 0.08), child: RedButton('Back to home', () => Navigator.popUntil(context, (r) => r.settings.name == '/home'))),
              SizedBox(height: 14),
              Padding(padding: EdgeInsets.symmetric(horizontal: w * 0.08), child: RedButton(Repo.i.isFav(_r) ? 'Saved' : 'Save recipes', () async {
                await Repo.i.toggleFav(_r);
                if (mounted) { setState(() {}); Navigator.pushNamed(context, '/saved'); }
              }, icon: Icons.bookmark)),
              SizedBox(height: h * 0.05),
            ]),
          ]);
        }),
      );
}

/// Confetti that falls once and settles around the top of the screen; positions are fractions of the size.
class _Confetti extends CustomPainter {
  final double t;
  _Confetti(this.t);
  static const colors = [Color(0xFFF5A623), Color(0xFFF40000), Color(0xFF2F80ED), Color(0xFF9B51E0), Color(0xFFF2C94C), Color(0xFF27AE60)];
  static final parts = () {
    final r = Random(7);
    return List.generate(46, (i) => [r.nextDouble(), r.nextDouble() * 0.5, r.nextDouble() * 0.5 + 0.25, r.nextDouble() * 3.14, r.nextDouble()]);
  }();
  @override
  void paint(Canvas c, Size s) {
    final ease = Curves.easeOut.transform(t);
    for (var i = 0; i < parts.length; i++) {
      final p = parts[i];
      final x = p[0] * s.width;
      final y = (-0.1 + (p[1] + 0.1) * ease) * s.height;       // falls from above the top edge to its resting place
      final size = (s.width * 0.018).clamp(5.0, 9.0) * (0.8 + p[4] * 0.6);
      c.save();
      c.translate(x, y);
      c.rotate(p[3] + t * 4 * (p[4] - 0.5));
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: size * 1.6, height: size), Radius.circular(2)), Paint()..color = colors[i % colors.length]);
      c.restore();
    }
  }
  @override
  bool shouldRepaint(_Confetti o) => o.t != t;
}
