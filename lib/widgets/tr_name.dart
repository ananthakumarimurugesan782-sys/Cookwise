import 'package:flutter/material.dart';
import '../data/repo.dart';
import '../data/translate.dart';
import '../l10n/strings.dart';

/// Ingredient name in the chosen language: word list first, then the translation service, else English.
class TrName extends StatelessWidget {
  final String name;
  final TextStyle? style;
  const TrName(this.name, {super.key, this.style});
  @override
  Widget build(BuildContext context) {
    if (Repo.i.language == 'English') return Text(name, style: style);
    final known = tIngKnown(name);
    if (known != null) return Text(known, style: style);
    return FutureBuilder<String>(
      future: Translate.i.text(name),
      initialData: name,
      builder: (c, s) => Text(s.data ?? name, style: style),
    );
  }
}
