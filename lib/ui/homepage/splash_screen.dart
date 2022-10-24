import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/ui/bottom_nav/bottom_navigation.dart';
import 'package:food_recipe_app/ui/homepage/home_page.dart';
import 'package:food_recipe_app/ui/homepage/recipe_list.dart';
import 'package:page_transition/page_transition.dart';

class SplashS extends StatefulWidget {
  const SplashS({Key? key}) : super(key: key);

  @override
  State<SplashS> createState() => _SplashSState();
}

class _SplashSState extends State<SplashS> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(context,
          PageTransition(child: BottomNavbar(), type: PageTransitionType.fade));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset('assets/splash_screen.png', fit: BoxFit.cover,),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Color(0x4a000000),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 100),
            alignment: Alignment.bottomCenter,
            child: CircularProgressIndicator(color: Colors.orange),
          ),
          Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 80),
              child: Image.asset('assets/title_logo.png', fit: BoxFit.cover,)
          ),
        ],
      ),
    );
  }
}