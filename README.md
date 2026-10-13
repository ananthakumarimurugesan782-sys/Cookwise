# CookWise (Flutter) - project folder: cook_wise

## Run
1. `flutter create .` once inside this folder (generates android/ios runners; keeps lib/, assets/, pubspec.yaml)
2. `flutter pub get`
3. `flutter run`

## Data
`assets/data/recipes.json` is generated from `dataset.csv` (semicolon-separated, cp1252) by
`python tools_build_recipes.py dataset.csv` (1,500 recipes: Indian, Italian, Chinese, Mexican, Japanese, Korean).
Edit LIM in the script to include more.

## Images
`assets/images/` holds crops taken from your wireframes (splash, logo, cuisine tiles, method art,
dish photos). The dataset has no image column, so a dish gets a photo only when one of YOUR
supplied images matches (see Repo.imageFor); otherwise a neutral placeholder shows.
To add more: drop a real photo in assets/images and add a keyword -> file entry in Repo.imageFor.

## Platforms
Generate runners for both: `flutter create --platforms=android,windows .`
Run on Windows: `flutter run -d windows`. On wide windows the app shows as a centred phone-width column.
Android needs internet for recipe photos: add `<uses-permission android:name="android.permission.INTERNET"/>`
to `android/app/src/main/AndroidManifest.xml` (above `<application>`).

## Firebase / release
See DEPLOYMENT.md (Firebase, Google sign-in, Translation API key, Google Play).

Firebase is built in. After `flutter create .` run `dart tools/setup_android.dart`, then `flutterfire configure` (see DEPLOYMENT.md).
