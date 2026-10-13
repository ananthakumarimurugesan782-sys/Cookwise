import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../theme.dart';

const countryCodes = {
  'India': '+91', 'United States / Canada': '+1', 'United Kingdom': '+44', 'United Arab Emirates': '+971', 'Saudi Arabia': '+966',
  'Qatar': '+974', 'Kuwait': '+965', 'Oman': '+968', 'Bahrain': '+973', 'Singapore': '+65', 'Malaysia': '+60', 'Sri Lanka': '+94',
  'Nepal': '+977', 'Bangladesh': '+880', 'Pakistan': '+92', 'Australia': '+61', 'New Zealand': '+64', 'Germany': '+49', 'France': '+33',
  'Italy': '+39', 'Japan': '+81', 'China': '+86', 'South Korea': '+82', 'Indonesia': '+62', 'Thailand': '+66', 'Mexico': '+52',
  'Brazil': '+55', 'South Africa': '+27', 'Russia': '+7',
};

/// Email / phone input. When the user types digits only, a country-code picker (default +91) appears.
class IdField extends StatefulWidget {
  const IdField({super.key});
  @override
  State<IdField> createState() => IdFieldState();
}

class IdFieldState extends State<IdField> {
  final ctl = TextEditingController();
  String code = '+91';
  String? error;

  bool get isPhone => RegExp(r'^[0-9][0-9 ]*$').hasMatch(ctl.text.trim());

  /// Validates and returns an error key (English) or null.
  String? validate() {
    final v = ctl.text.trim();
    String? e;
    if (v.isEmpty) {
      e = 'Enter a valid email or phone number';
    } else if (isPhone) {
      final d = v.replaceAll(' ', '');
      if (code == '+91') {
        if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(d)) e = 'Enter a valid 10-digit mobile number';
      } else if (d.length < 6 || d.length > 14) {
        e = 'Enter a valid mobile number';
      }
    } else if (!RegExp(r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$').hasMatch(v)) {
      e = 'Enter a valid email or phone number';
    }
    setState(() => error = e);
    return e;
  }

  /// Normalised id used for the account: lowercase email, or +<code><digits>.
  String get value => isPhone ? '$code${ctl.text.replaceAll(' ', '')}' : ctl.text.trim().toLowerCase();

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: error != null ? Border.all(color: Colors.red) : null),
          child: Row(children: [
            if (isPhone)
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: code, isDense: true, style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: kFont),
                  items: [for (final e in countryCodes.entries) DropdownMenuItem(value: e.value, child: Text('${e.value}  ${e.key}', style: TextStyle(fontSize: 13)))],
                  selectedItemBuilder: (c) => [for (final e in countryCodes.entries) Center(child: Text(e.value))],
                  onChanged: (v) => setState(() => code = v ?? '+91'),
                ),
              )
            else
              Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Icon(Icons.badge_outlined, color: kRed, size: 18)),
            Expanded(child: TextField(
              controller: ctl, keyboardType: TextInputType.emailAddress, onChanged: (_) => setState(() => error = null),
              decoration: InputDecoration(border: InputBorder.none, hintText: t('Email/phone number')),
            )),
          ]),
        ),
        if (error != null) Padding(padding: EdgeInsets.fromLTRB(14, 4, 14, 0), child: Text(t(error!), style: TextStyle(color: Colors.red, fontSize: 11))),
      ]);
}
