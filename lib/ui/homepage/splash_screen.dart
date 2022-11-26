import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/ui/bottom_nav/bottom_navigation.dart';
import 'package:food_recipe_app/ui/homepage/home_page.dart';
import 'package:food_recipe_app/ui/homepage/recipe_list.dart';
import 'package:food_recipe_app/ui/login/login_page.dart';
import 'package:page_transition/page_transition.dart';

class SplashS extends StatefulWidget {
  const SplashS({Key? key}) : super(key: key);

  @override
  State<SplashS> createState() => _SplashSState();
}

class _SplashSState extends State<SplashS> {
  Future<FirebaseApp> _initializedFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(context,
          PageTransition(child: FutureBuilder(
            future: _initializedFirebase(),
            builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return FirebaseAuth.instance.currentUser == null ?  const LoginPage() : BottomNavbar();
            }
            return const Center(child: CircularProgressIndicator());
          },), type: PageTransitionType.fade));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.black, statusBarBrightness: Brightness.dark, systemNavigationBarColor: Colors.white));
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
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
