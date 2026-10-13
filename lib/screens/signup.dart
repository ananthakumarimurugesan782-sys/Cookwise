import 'package:flutter/material.dart';
import '../data/repo.dart';
import '../l10n/strings.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/id_field.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final idKey = GlobalKey<IdFieldState>();
  final name = TextEditingController(), pw = TextEditingController(), pw2 = TextEditingController();
  String? nameErr, pwErr, pw2Err, err;
  bool hide = true;

  Widget box(TextEditingController c, String hint, IconData icon, String? error, {bool secret = false}) => Padding(
        padding: EdgeInsets.fromLTRB(30, 6, 30, 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: error != null ? Border.all(color: Colors.red) : null),
            child: TextField(controller: c, obscureText: secret && hide, onChanged: (_) => setState(() { nameErr = null; pwErr = null; pw2Err = null; }),
                decoration: InputDecoration(border: InputBorder.none, hintText: t(hint), prefixIcon: Icon(icon, color: kRed, size: 18),
                    suffixIcon: secret ? IconButton(icon: Icon(Icons.remove_red_eye, color: kRed, size: 18), onPressed: () => setState(() => hide = !hide)) : null)),
          ),
          if (error != null) Padding(padding: EdgeInsets.fromLTRB(14, 4, 14, 0), child: Text(t(error), style: TextStyle(color: Colors.red, fontSize: 11))),
        ]),
      );

  Future<void> submit() async {
    final idErr = idKey.currentState!.validate();
    final n = name.text.trim().length < 2 ? 'Enter your name' : null;
    final p = pw.text.length < 6 ? 'Password must be at least 6 characters' : null;
    final p2 = (p == null && pw2.text != pw.text) ? 'Passwords do not match' : null;
    setState(() { nameErr = n; pwErr = p; pw2Err = p2; err = null; });
    if (idErr != null || n != null || p != null || p2 != null) return;
    final r = await Repo.i.signUp(name.text, idKey.currentState!.value, pw.text);
    if (!mounted) return;
    if (r != null) { setState(() => err = r); return; }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('Account created'))));
    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
  }

  @override
  Widget build(BuildContext context) => AppPage(
        child: SingleChildScrollView(child: Column(children: [
          Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(14), child: BackDot())),
          Image.asset('assets/images/chef_hat_red.png', height: 70),
          Text('COOK WISE', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Container(margin: EdgeInsets.fromLTRB(30, 14, 30, 16), padding: EdgeInsets.all(12), width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(t('Create Account'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
          box(name, 'Full name', Icons.person_outline, nameErr),
          Padding(padding: EdgeInsets.fromLTRB(30, 6, 30, 6), child: IdField(key: idKey)),
          box(pw, 'Password', Icons.lock_outline, pwErr, secret: true),
          box(pw2, 'Confirm password', Icons.lock_outline, pw2Err, secret: true),
          if (err != null) Padding(padding: EdgeInsets.fromLTRB(30, 6, 30, 0), child: Text(t(err!), textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 12))),
          SizedBox(height: 14),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: RedButton('Sign up', submit)),
          SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(t('Already have an account ? '), style: TextStyle(fontSize: 12)),
            GestureDetector(onTap: () => Navigator.pop(context), child: Text(t('Login'), style: TextStyle(fontSize: 12, color: kRed))),
          ]),
          SizedBox(height: 20),
        ])),
      );
}
