import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/theme/color_primary.dart';
import 'package:food_recipe_app/ui/favorite_page/favorite_list.dart';
import 'package:food_recipe_app/ui/homepage/home_page.dart';
import 'package:food_recipe_app/ui/homepage/recipe_list.dart';

class BottomNavbar extends StatefulWidget {
  BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentindex = 0;
  final Screens = [
    const HomePage(),
    RecipeList(),
    ListMoviePage(),
    RecipeList()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: MyColor.primary,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentindex,
          onTap: (index) => setState(
                () => currentindex = index,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
                icon: Transform.rotate(
                  angle: 180 * pi / 90,
                  child: Icon(Icons.favorite),
                ),
                label: "Favorite"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: 18,
              ),
              label: "Account",
            ),
          ]),
    );
  }
}
