import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../data/images.dart';
import '../data/repo.dart';
import '../models/recipe.dart';
import '../theme.dart';

class AppPage extends StatelessWidget {
  final Widget child;
  final Widget? bottom;
  AppPage({super.key, required this.child, this.bottom});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: kBg,
        body: SafeArea(child: child), // no AppBar: only the system time/battery bar shows
        bottomNavigationBar: bottom,
      );
}

class BackPill extends StatelessWidget {
  final String title;
  BackPill(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          BackDot(),
          SizedBox(width: 12),
          Expanded(child: Text(t(title), style: TextStyle(fontSize: 16))),
        ]),
      );
}

class BackDot extends StatelessWidget {
  BackDot({super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: CircleAvatar(radius: 11, backgroundColor: Colors.black,
            child: Icon(Icons.arrow_back, size: 14, color: Colors.white)),
      );
}

class RedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool arrows;
  final IconData? icon;
  RedButton(this.label, this.onTap, {super.key, this.arrows = false, this.icon});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(22)),
          alignment: Alignment.center,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) ...[Icon(icon, color: Colors.white, size: 18), SizedBox(width: 8)],
            Text(t(label), style: TextStyle(color: Colors.white, fontSize: 15)),
            if (arrows) ...[SizedBox(width: 10), Icon(Icons.keyboard_double_arrow_right, color: Colors.white, size: 18)],
          ]),
        ),
      );
}

class BottomNav extends StatelessWidget {
  final bool withSearch;
  BottomNav({super.key, this.withSearch = false});
  @override
  Widget build(BuildContext context) {
    Widget item(IconData i, String tt, String route) => GestureDetector(
          onTap: () => route == '/home'
              ? Navigator.popUntil(context, (r) => r.settings.name == '/home')
              : Navigator.pushNamed(context, route),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(i, color: Colors.white), Text(t(tt), style: TextStyle(color: Colors.white, fontSize: 12)),
          ]),
        );
    return Container(
      color: kRed, padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: SafeArea(top: false, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        item(Icons.home, 'Home', '/home'),
        if (withSearch) item(Icons.search, 'Search', '/cuisine_list'),
        item(Icons.shopping_cart, 'Shop', '/shopping'),
        item(Icons.account_circle_outlined, 'My Profile', '/profile'),
      ])),
    );
  }
}

/// Recipe photo. Order: (1) your wireframe photo when [preferAsset] and one matches,
/// (2) the real photo of this exact recipe (found via its dataset page URL),
/// (3) a matching wireframe photo, (4) a neutral placeholder. Never one picture for all.
class RecipeImage extends StatefulWidget {
  final Recipe r;
  final double w, h;
  final bool preferAsset;
  RecipeImage(this.r, {super.key, this.w = 112, this.h = 76, this.preferAsset = false});
  @override
  State<RecipeImage> createState() => _RecipeImageState();
}

class _RecipeImageState extends State<RecipeImage> {
  late final Future<String?>? f = widget.r.image.isEmpty ? ImageService.i.urlFor(widget.r) : null;
  @override
  Widget build(BuildContext context) {
    final w = widget.w, h = widget.h;
    final asset = Repo.i.imageFor(widget.r);
    final ph = Container(width: w, height: h, color: Color(0xFFEFEAC0), child: Icon(Icons.restaurant, color: Colors.black38));
    Widget fromAsset() => asset == null ? ph : Image.asset(asset, width: w, height: h, fit: BoxFit.cover, errorBuilder: (_, __, ___) => ph);
    Widget body;
    if (widget.preferAsset && asset != null) {
      body = fromAsset();
    } else if (widget.r.image.isNotEmpty) {
      // the dataset's own photo for this exact recipe
      body = Image.network(widget.r.image, width: w, height: h, fit: BoxFit.cover,
          loadingBuilder: (c, child, p) => p == null ? child : ph, errorBuilder: (_, __, ___) => fromAsset());
    } else {
      body = FutureBuilder<String?>(
        future: f,
        builder: (c, snap) {
          if (snap.connectionState != ConnectionState.done) return ph;
          final u = snap.data;
          if (u == null) return fromAsset();
          return Image.network(u, width: w, height: h, fit: BoxFit.cover,
              loadingBuilder: (c, child, p) => p == null ? child : ph, errorBuilder: (_, __, ___) => fromAsset());
        },
      );
    }
    return ClipRRect(borderRadius: BorderRadius.circular(6), child: SizedBox(width: w == double.infinity ? null : w, height: h, child: body));
  }
}

class RecipeRow extends StatelessWidget {
  final Recipe r;
  final VoidCallback onTap;
  final Widget? trailing;
  RecipeRow(this.r, this.onTap, {super.key, this.trailing});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            RecipeImage(r),
            SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13)),
              if (r.totalMins != null) Text(tf('Time Taken : {n} mins', {'n': '${r.totalMins}'}), style: TextStyle(fontSize: 11)),
              Text(t(r.cuisine), style: TextStyle(fontSize: 11)),
            ])),
            trailing ?? CircleAvatar(radius: 9, backgroundColor: Colors.black,
                child: Icon(Icons.arrow_forward_ios, size: 9, color: Colors.white)),
          ]),
        ),
      );
}

/// Opens the people -> method -> ingredients flow for a recipe.
void startRecipe(BuildContext c, Recipe r) {
  Repo.i.current = r;
  Repo.i.people = r.servings.clamp(1, 20);
  Navigator.pushNamed(c, '/trad_modern');
}
