import 'package:flutter/material.dart';
import 'package:food_recipe_app/theme/color_primary.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      width: 150,
      child: Container(
        margin: const EdgeInsets.only(top: 230),
        child: Column(
          children: [
            InkWell(
              onTap: (){},
              child: Container(
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: const [
                    Icon(Icons.home, color: Colors.white, size: 30,),
                    Text(' Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: const [
                    Icon(Icons.history, color: Colors.white, size: 30,),
                    Text(' History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: const [
                    Icon(Icons.settings, color: Colors.white, size: 30,),
                    Text(' Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
