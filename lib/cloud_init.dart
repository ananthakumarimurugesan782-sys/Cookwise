// Firebase add-on: copy this file over lib/cloud_init.dart (see DEPLOYMENT.md, "Add Firebase").
import 'package:firebase_core/firebase_core.dart';
import 'data/firebase_backend.dart';
import 'data/repo.dart';
import 'firebase_options.dart';

Future<void> initCloud() async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    Repo.cloud = FirebaseBackend();
  } catch (_) {
    Repo.cloud = null; // Firebase not configured: fall back to local demo accounts
  }
}
