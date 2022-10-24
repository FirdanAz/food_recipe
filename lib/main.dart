import 'package:flutter/material.dart';
import 'package:food_recipe_app/ui/homepage/recipe_list.dart';
import 'package:food_recipe_app/ui/homepage/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashS(),
      debugShowCheckedModeBanner: false,
    );
  }
}