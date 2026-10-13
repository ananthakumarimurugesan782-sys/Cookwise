# CookWise - Firebase, API keys and Google Play release (step by step)

Do the steps in order. Every command is run in the project folder (`cook_wise`) unless it says otherwise.

## 0. First make sure the app runs
1. `flutter create --platforms=android,windows .`  (once, adds the android/ and windows/ runners)
2. `flutter pub get`
3. `flutter analyze` and `flutter run` - fix any errors before continuing.
Without Firebase the app runs with local demo accounts, so you can test everything first.

## 1. Pick your Android package name
Choose a unique id such as `com.yourname.cookwise` (it can never change after you publish).
Set it in `android/app/build.gradle(.kts)` -> `applicationId`, and `namespace` to the same value.
Also in that file set `minSdk = 23` (Firebase needs 23 or higher).
In `android/app/src/main/AndroidManifest.xml` add above `<application>`:
`<uses-permission android:name="android.permission.INTERNET"/>` and set `android:label="CookWise"`.

## 2. Connect your Firebase project (Firebase is already inside the app)
1. https://console.firebase.google.com -> Add project -> name it CookWise.
2. Install the tools once: `npm install -g firebase-tools`, then `dart pub global activate flutterfire_cli`, then `firebase login`.
3. In the project folder: `flutter create --platforms=android,windows .` then `dart tools/setup_android.dart`
   (this sets minSdk 23 and the INTERNET permission for you).
4. `flutterfire configure` -> choose your project -> tick Android -> it asks for the package name.
   It **overwrites `lib/firebase_options.dart`** and downloads `android/app/google-services.json`.
5. `flutter pub get` then `flutter run`. Until step 4 is done the app still runs, using local demo accounts.

## 3. Turn on Authentication
Firebase console -> Build -> Authentication -> Get started -> Sign-in method:
- **Email/Password** -> Enable.
- **Google** -> Enable -> choose a project support email -> Save.
  Phone numbers: the app maps a phone number to a private pseudo-email so people can sign up with
  number + password. It does NOT verify the number by SMS. For SMS verification use Firebase Phone
  Authentication later (needs the Blaze plan).

## 4. Firestore (saves favourites per user)
Firebase console -> Build -> Firestore Database -> Create database (production mode, pick a region near your users, e.g. asia-south1).
Then publish the rules in `firestore.rules`: `firebase init firestore` (choose the existing project and keep `firestore.rules`) and `firebase deploy --only firestore:rules`,
or paste the file into Firestore -> Rules -> Publish.

## 5. Make "Continue with Google" work for everyone
1. SHA fingerprints. Google sign-in only works for apps whose signing key is registered.
   Debug key: `cd android && ./gradlew signingReport` (Windows: `gradlew signingReport`) and copy the SHA-1 and SHA-256 of the `debug` variant.
   Firebase console -> Project settings -> Your apps -> Android app -> Add fingerprint (SHA-1 and SHA-256). Do this again for your release key (step 8) and for the Play App Signing key (step 10).
2. Re-download `google-services.json` after adding fingerprints and put it in `android/app/`.
3. Web client id: Firebase console -> Authentication -> Sign-in method -> Google -> Web SDK configuration -> copy "Web client ID".
   Run/build with `--dart-define=GOOGLE_SERVER_CLIENT_ID=<that id>` (needed on Android).
4. **Open it to all Google users:** https://console.cloud.google.com -> select the same project -> APIs & Services (or "Google Auth Platform") -> OAuth consent screen -> Audience:
   - User type: **External**
   - Fill app name, support email, developer contact email, privacy policy link and authorised domain.
   - Click **Publish app** so the status is **In production**. While it says "Testing", only the test users you list (max 100) can sign in.
   - CookWise only asks for the basic scopes (email, profile, openid), so Google does not require a verification review for these.

## 6. Translation API key (for translating cooking steps)
All screens are translated from built-in text. Recipe steps (and rare ingredient names) are English in the dataset, so the app translates them with Google Cloud Translation:
1. https://console.cloud.google.com -> same project -> enable billing (the free tier is 500,000 characters per month) -> APIs & Services -> Library -> **Cloud Translation API** -> Enable.
2. APIs & Services -> Credentials -> Create credentials -> **API key**.
3. Restrict it: Application restrictions -> Android apps -> add your package name + the SHA-1 of the release and Play signing keys; API restrictions -> Cloud Translation API only.
4. Use it only through the build flag - never paste it into the source code:
   `flutter run --dart-define=TRANSLATE_API_KEY=YOUR_KEY`
5. Set a budget alert in Google Cloud (Billing -> Budgets & alerts). A key inside an app can be extracted by determined users, so restrictions and a budget alert matter.
   Later you can move translation into a Firebase Cloud Function so the key never ships in the app.
Without a key the steps simply stay in English.

## 7. App icon and name
`flutter pub add --dev flutter_launcher_icons`, add your 1024x1024 icon in `pubspec.yaml` under `flutter_launcher_icons:` and run `dart run flutter_launcher_icons`.

## 8. Create the release signing key
```
keytool -genkey -v -keystore %USERPROFILE%\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
(macOS/Linux: `-keystore ~/upload-keystore.jks`). Keep this file and its passwords safe and **never commit them**.
Create `android/key.properties`:
```
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=C:/Users/YOU/upload-keystore.jks
```
In `android/app/build.gradle.kts` (Groovy `build.gradle` is similar) add at the top:
```kotlin
import java.util.Properties
val keystoreProperties = Properties().apply { val f = rootProject.file("key.properties"); if (f.exists()) load(f.inputStream()) }
```
inside `android { ... }`:
```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}
buildTypes { getByName("release") { signingConfig = signingConfigs.getByName("release") } }
```
Add the release key's SHA-1/SHA-256 to Firebase (step 5.1): `keytool -list -v -keystore upload-keystore.jks -alias upload`.

## 9. Build the release bundle
Set `version: 1.0.0+1` in `pubspec.yaml` (the number after + must increase with every upload).
```
flutter build appbundle --release --dart-define=TRANSLATE_API_KEY=YOUR_KEY --dart-define=GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID
```
Output: `build/app/outputs/bundle/release/app-release.aab`. Test the release build on a real phone first:
`flutter build apk --release ...` then install it.

## 10. Publish on Google Play
1. https://play.google.com/console -> create a developer account (one-time US$25 fee, identity verification).
2. Create app -> name, default language, App, Free.
3. Complete: **Store listing** (short + full description, 512x512 icon, 1024x500 feature graphic, at least 2 phone screenshots), **Content rating** questionnaire, **Target audience**, **Ads** (none), **Data safety** (you collect: name, email/phone, app activity such as favourites; data is encrypted in transit; users can request deletion), **Privacy policy URL** (required because the app has accounts - host a simple page, e.g. on Firebase Hosting or GitHub Pages), **App access** (login is required: give Google a test email and password).
4. Testing -> Internal testing -> Create release -> upload the `.aab` -> add yourself as a tester -> install from the Play link and check sign-in, Google sign-in and recipes.
5. **Play App Signing key:** Play Console -> Test and release -> App integrity -> copy the *App signing key certificate* SHA-1 and SHA-256 -> add them in Firebase (step 5.1) and in the Translation API key restriction (step 6.3). Without this, Google sign-in fails for people who install from Play.
6. Production access: new personal developer accounts must first run a **closed test with the minimum number of testers for 14 days** (currently 12 - check Play Console for the up-to-date rule), then you can apply for production. Organisation accounts skip this.
7. Production -> Create release -> choose countries -> submit for review (usually a few days).

## 11. Updating the app later
Increase the build number (`1.0.1+2`), run the build command, upload the new `.aab` to a new release.

## Notes
- Favourites are stored in Firestore under each recipe's number (`id`). Keep `assets/data/recipes.json` stable after launch; regenerating it can shift the numbers.
- Windows build (`flutter build windows`) works for email/password and Firestore; Google sign-in is Android/iOS only.
- Google sign-in error codes 10 / 12500 / "DEVELOPER_ERROR" nearly always mean a missing SHA fingerprint or an old `google-services.json`.
