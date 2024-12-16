import 'package:coffe_app/config/routes.dart';
import 'package:coffe_app/core/utils/app_strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CoffeeShopApp());
}

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
          fontFamily: 'Sora',
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.white)),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppStrings.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
