import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/theme/color_primary.dart';
import 'package:food_recipe_app/ui/bottom_nav/bottom_navigation.dart';
import 'package:food_recipe_app/ui/detailpage/new_detail.dart';
import 'package:food_recipe_app/ui/homepage/home_page.dart';
import 'package:food_recipe_app/ui/homepage/splash_screen.dart';
import 'package:food_recipe_app/ui/sign_up/sign_up.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.black, statusBarBrightness: Brightness.dark));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      color: MyColor.primary,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashS(),
      debugShowCheckedModeBanner: false,
    );
  }
}