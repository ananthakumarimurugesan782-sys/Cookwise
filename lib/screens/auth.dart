import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../data/repo.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/id_field.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(fit: StackFit.expand, children: [
          Image.asset('assets/images/splash_bg.png', fit: BoxFit.cover),
          SafeArea(child: Column(children: [
            SizedBox(height: 40),
            ClipOval(child: Image.asset('assets/images/logo_splash.png', width: 190, height: 190, fit: BoxFit.cover)),
            Spacer(flex: 3),
            Padding(padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
                child: RedButton('START', () => Repo.i.loggedIn ? Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false) : Navigator.pushNamed(context, '/language'))),
            Spacer(flex: 4),
          ])),
        ]),
      );
}

class LanguageScreen extends StatefulWidget {
  LanguageScreen({super.key});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static final langs = ['English', 'Tamil', 'Hindi', 'Telugu', 'Malayalam', 'Kannada'];
  late String sel = Repo.i.language;
  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          BackPill('Choose Language'),
          Padding(padding: EdgeInsets.fromLTRB(28, 14, 12, 14),
              child: Align(alignment: Alignment.centerLeft, child: Text(t('select your preferred language to continue,')))),
          Expanded(child: ListView(children: [
            for (final l in langs)
              GestureDetector(
                onTap: () => setState(() { sel = l; Repo.i.language = l; }),  // preview the language immediately
                child: Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8), padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                      border: sel == l ? Border.all(color: kRed) : null),
                  child: Row(children: [
                    CircleAvatar(radius: 9, backgroundColor: Colors.black,
                        child: Icon(Icons.arrow_forward_ios, size: 9, color: Colors.white)),
                    SizedBox(width: 20), Text(l),
                  ]),
                ),
              ),
          ])),
          Padding(padding: EdgeInsets.fromLTRB(60, 8, 60, 20), child: RedButton('Continue', () async {
            await Repo.i.setLanguage(sel);
            if (!context.mounted) return;
            final a = ModalRoute.of(context)?.settings.arguments;
            if (a is Map && a['fromProfile'] == true) {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false); // rebuild screens in the new language
            } else {
              Navigator.pushNamed(context, '/login');
            }
          }, arrows: true)),
        ]),
      );
}

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idKey = GlobalKey<IdFieldState>();
  final pw = TextEditingController();
  bool hide = true;
  String? pwErr, err;

  Future<void> submit() async {
    final e = idKey.currentState!.validate();
    String? pe = pw.text.isEmpty ? 'Password must be at least 6 characters' : null;
    setState(() { pwErr = pe; err = null; });
    if (e != null || pe != null) return;
    final r = await Repo.i.login(idKey.currentState!.value, pw.text);
    if (!mounted) return;
    if (r != null) { setState(() => err = r); return; }
    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
  }

  @override
  Widget build(BuildContext context) => AppPage(
        child: SingleChildScrollView(child: Column(children: [
          SizedBox(height: 16),
          Image.asset('assets/images/chef_hat_red.png', height: 80),
          Text('COOK WISE', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(t('Cook smart,eat better'), style: TextStyle(fontSize: 11)),
          Container(margin: EdgeInsets.fromLTRB(30, 14, 30, 24), padding: EdgeInsets.all(14), width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(t('Login  / Sign up'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: IdField(key: idKey)),
          SizedBox(height: 14),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: pwErr != null ? Border.all(color: Colors.red) : null),
              child: TextField(controller: pw, obscureText: hide, onChanged: (_) => setState(() => pwErr = null), decoration: InputDecoration(
                border: InputBorder.none, hintText: t('Password'), prefixIcon: Icon(Icons.person, color: kRed, size: 18),
                suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye, color: kRed, size: 18), onPressed: () => setState(() => hide = !hide)))),
            ),
            if (pwErr != null) Padding(padding: EdgeInsets.fromLTRB(14, 4, 14, 0), child: Text(t(pwErr!), style: TextStyle(color: Colors.red, fontSize: 11))),
          ])),
          Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.only(right: 36, top: 6),
              child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/forgot'),
                  child: Text(t('Forgot password ?'), style: TextStyle(fontSize: 12))))),
          if (err != null) Padding(padding: EdgeInsets.only(top: 8, left: 30, right: 30), child: Text(t(err!), textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 12))),
          SizedBox(height: 12),
          GestureDetector(onTap: submit,
              child: Container(padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Text(t('Login')))),
          Padding(padding: EdgeInsets.all(20), child: Row(children: [
            Expanded(child: Divider(color: Colors.black)), Padding(padding: EdgeInsets.all(8), child: Text(t('or'))), Expanded(child: Divider(color: Colors.black))])),
          GestureDetector(onTap: () async {
                final r = await Repo.i.googleSignIn();
                if (!mounted) return;
                if (r == null) { Navigator.pushNamedAndRemoveUntil(context, '/home', (x) => false); }
                else if (r.isNotEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t(r)))); }
              },
              child: Container(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(color: Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(16)),
                  child: Text(t('Continue with google'), style: TextStyle(fontSize: 12)))),
          SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(t("Don't have an account ? "), style: TextStyle(fontSize: 12)),
            GestureDetector(onTap: () => Navigator.pushNamed(context, '/signup'),
                child: Text(t('Sign up'), style: TextStyle(fontSize: 12, color: kRed))),
          ]),
          SizedBox(height: 16),
        ])),
      );
}

class ForgotScreen extends StatefulWidget {
  ForgotScreen({super.key});
  @override
  State<ForgotScreen> createState() => _ForgotState();
}

class _ForgotState extends State<ForgotScreen> {
  final ctl = TextEditingController();
  String? err;
  bool busy = false;

  Future<void> send() async {
    final v = ctl.text.trim().toLowerCase();
    if (!RegExp(r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$').hasMatch(v)) {
      setState(() => err = 'Enter a valid email or phone number');
      return;
    }
    setState(() { busy = true; err = null; });
    final r = await Repo.i.resetPassword(v);
    if (!mounted) return;
    setState(() { busy = false; err = r; });
    if (r == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('Reset link sent to your email'))));
    }
  }

  @override
  Widget build(BuildContext context) => AppPage(
        child: Column(children: [
          Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(14), child: BackDot())),
          Image.asset('assets/images/forgot_lock.png', height: 100),
          SizedBox(height: 14),
          Text(t('Forgot Password?'), style: TextStyle(fontSize: 26)),
          Padding(padding: EdgeInsets.all(14), child: Text(t("Don't worry! Enter your registered email\nand we'll send you a password reset link"),
              textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black54))),
          Spacer(),
          Container(margin: EdgeInsets.symmetric(horizontal: 20), padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: err != null ? Border.all(color: Colors.red) : null),
              child: TextField(controller: ctl, keyboardType: TextInputType.emailAddress, onChanged: (_) => setState(() => err = null),
                  decoration: InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.mail_outline), labelText: t('Email Address'), hintText: t('Enter your email')))),
          if (err != null) Padding(padding: EdgeInsets.fromLTRB(24, 6, 24, 0), child: Align(alignment: Alignment.centerLeft, child: Text(t(err!), style: TextStyle(color: Colors.red, fontSize: 11)))),
          SizedBox(height: 24),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: RedButton('Send Reset Link', () { if (!busy) send(); })),
          SizedBox(height: 14),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: RedButton('Back to Login', () => Navigator.pop(context))),
          SizedBox(height: 40),
        ]),
      );
}
