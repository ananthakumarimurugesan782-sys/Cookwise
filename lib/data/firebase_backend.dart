import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:google_sign_in/google_sign_in.dart';
import 'cloud.dart';

/// Firebase Authentication + Firestore implementation of CloudBackend.
class FirebaseBackend implements CloudBackend {
  static bool _gInit = false;
  fa.User? get _fu => fa.FirebaseAuth.instance.currentUser;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  // Firebase email/password needs an email: phone numbers are mapped to a private pseudo-email.
  String _email(String id) => id.startsWith('+') ? 'p${id.substring(1)}@phone.cookwise.app' : id;

  @override
  bool get loggedIn => _fu != null;

  @override
  String? get userName {
    final u = _fu;
    if (u == null) return null;
    if ((u.displayName ?? '').isNotEmpty) return u.displayName;
    return (u.email ?? '').split('@').first;
  }

  String _err(fa.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use': return 'An account with this email/number already exists';
      case 'invalid-email': return 'Enter a valid email or phone number';
      case 'weak-password': return 'Password must be at least 6 characters';
      case 'user-not-found': return 'Account not found. Please sign up first.';
      case 'wrong-password': return 'Incorrect password';
      case 'invalid-credential':
      case 'invalid-login-credentials': return 'Incorrect email/number or password';
      case 'network-request-failed': return 'Check your internet connection';
      default: return 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<String?> signUp(String name, String id, String pw) async {
    try {
      final c = await fa.FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email(id), password: pw);
      await c.user!.updateDisplayName(name.trim());
      await c.user!.reload();
      await _db.collection('users').doc(c.user!.uid).set({'name': name.trim(), 'id': id, 'createdAt': FieldValue.serverTimestamp()});
      return null;
    } on fa.FirebaseAuthException catch (e) {
      return _err(e);
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<String?> login(String id, String pw) async {
    try {
      await fa.FirebaseAuth.instance.signInWithEmailAndPassword(email: _email(id), password: pw);
      return null;
    } on fa.FirebaseAuthException catch (e) {
      return _err(e);
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<String?> googleSignIn() async {
    try {
      if (!_gInit) {
        const sid = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
        await GoogleSignIn.instance.initialize(serverClientId: sid.isEmpty ? null : sid);
        _gInit = true;
      }
      final acc = await GoogleSignIn.instance.authenticate();
      final cred = fa.GoogleAuthProvider.credential(idToken: acc.authentication.idToken);
      final uc = await fa.FirebaseAuth.instance.signInWithCredential(cred);
      await _db.collection('users').doc(uc.user!.uid).set({'name': uc.user!.displayName ?? '', 'id': uc.user!.email ?? ''}, SetOptions(merge: true));
      return null;
    } on GoogleSignInException catch (e) {
      return e.code == GoogleSignInExceptionCode.canceled ? '' : 'Google sign-in failed';
    } on fa.FirebaseAuthException catch (e) {
      return _err(e);
    } catch (_) {
      return 'Google sign-in failed';
    }
  }

  @override
  Future<String?> resetPassword(String email) async {
    try {
      await fa.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on fa.FirebaseAuthException catch (e) {
      return e.code == 'user-not-found' ? 'Account not found. Please sign up first.' : _err(e);
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<void> logout() async {
    try { await GoogleSignIn.instance.signOut(); } catch (_) {}
    await fa.FirebaseAuth.instance.signOut();
  }

  @override
  Future<Set<int>> loadFavourites() async {
    final u = _fu;
    if (u == null) return {};
    final docs = await _db.collection('users').doc(u.uid).collection('favourites').get();
    return docs.docs.map((d) => int.tryParse(d.id)).whereType<int>().toSet();
  }

  @override
  Future<void> setFavourite(int recipeId, bool on) async {
    final u = _fu;
    if (u == null) return;
    final d = _db.collection('users').doc(u.uid).collection('favourites').doc('$recipeId');
    on ? await d.set({'at': FieldValue.serverTimestamp()}) : await d.delete();
  }
}
