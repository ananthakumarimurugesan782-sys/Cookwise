// Run after `flutter create .`:  dart tools/setup_android.dart
// Sets minSdk >= 23 (needed by Firebase), adds the INTERNET permission and the app name.
import 'dart:io';

void main() {
  final kts = File('android/app/build.gradle.kts');
  final groovy = File('android/app/build.gradle');
  final f = kts.existsSync() ? kts : groovy;
  if (!f.existsSync()) { stderr.writeln('Run `flutter create --platforms=android .` first.'); exit(1); }
  var s = f.readAsStringSync();
  final isKts = f.path.endsWith('.kts');
  s = s.replaceAllMapped(RegExp(r'minSdk(Version)?\s*=?\s*(flutter\.minSdkVersion|\d+)'), (m) {
    final v = m[2]!;
    if (v == 'flutter.minSdkVersion') {
      return isKts ? 'minSdk = maxOf(23, flutter.minSdkVersion)' : 'minSdk = Math.max(23, flutter.minSdkVersion)';
    }
    return 'minSdk = ${int.parse(v) < 23 ? 23 : int.parse(v)}';
  });
  f.writeAsStringSync(s);

  final m = File('android/app/src/main/AndroidManifest.xml');
  var x = m.readAsStringSync();
  if (!x.contains('android.permission.INTERNET')) {
    x = x.replaceFirst('<application', '<uses-permission android:name="android.permission.INTERNET"/>\n    <application');
  }
  x = x.replaceFirst(RegExp(r'android:label="[^"]*"'), 'android:label="CookWise"');
  m.writeAsStringSync(x);
  stdout.writeln('Android settings updated: minSdk >= 23, INTERNET permission, app name CookWise.');
}
