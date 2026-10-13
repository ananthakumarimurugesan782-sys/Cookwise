import 'package:flutter/material.dart';
import 'data/repo.dart';
import 'theme.dart';
import 'screens/auth.dart';
import 'screens/home.dart';
import 'screens/flow.dart';
import 'screens/lists.dart';
import 'screens/account.dart';
import 'screens/info.dart';
import 'screens/signup.dart';
import 'cloud_init.dart';
import 'data/images.dart';
import 'data/prices.dart';
import 'data/translate.dart';
import 'package:flutter/gestures.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initCloud();
  await Repo.i.load();
  await Translate.i.init();
  await ImageService.i.init();
  await PriceBook.i.load();
  runApp(const CookWiseApp());
}

class CookWiseApp extends StatelessWidget {
  const CookWiseApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'CookWise',
        debugShowCheckedModeBanner: false,
        theme: cookwiseTheme(),
        scrollBehavior: const _AnyDeviceScroll(),
        // Phone: full screen. Windows/tablet/wide window: a centred phone-width column.
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          if (mq.size.width < 600) return child!;
          const w = 430.0;
          final h = mq.size.height > 860 ? 860.0 : mq.size.height;
          return ColoredBox(
            color: const Color(0xFFE6E2B5),
            child: Center(child: Container(
              width: w, height: h,
              decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: Colors.black26))),
              child: ClipRect(child: MediaQuery(data: mq.copyWith(size: Size(w, h)), child: child!)),
            )),
          );
        },
        initialRoute: '/',
        routes: {
          '/': (_) => SplashScreen(),
          '/language': (_) => LanguageScreen(),
          '/login': (_) => LoginScreen(),
          '/signup': (_) => SignUpScreen(),
          '/forgot': (_) => ForgotScreen(),
          '/home': (_) => HomeScreen(),
          '/cuisines': (_) => CuisinesScreen(),
          '/cuisine_list': (_) => CuisineListScreen(),
          '/cook_with': (_) => CookWithIngredientsScreen(),
          '/people': (_) => PeopleScreen(),
          '/method': (_) => MethodScreen(),
          '/ingredients': (_) => IngredientsScreen(),
          '/availability': (_) => AvailabilityScreen(),
          '/shopping': (_) => ShoppingScreen(),
          '/allset': (_) => AllSetScreen(),
          '/steps': (_) => StepsScreen(),
          '/nutrition': (_) => NutritionScreen(),
          '/enjoy': (_) => EnjoyScreen(),
          '/saved': (_) => SavedScreen(),
          '/favourites': (_) => FavouritesScreen(),
          '/profile': (_) => ProfileScreen(),
          '/notifications': (_) => NotificationsScreen(),
          '/help': (_) => HelpScreen(),
          '/about': (_) => AboutScreen(),
          '/logout': (_) => LogoutScreen(),
          '/diet': (_) => DietScreen(),
          '/trad_modern': (_) => TradModernScreen(),
        },
      );
}

/// Lets mouse (Windows) drag-scroll lists like touch does on a phone.
class _AnyDeviceScroll extends MaterialScrollBehavior {
  const _AnyDeviceScroll();
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}
