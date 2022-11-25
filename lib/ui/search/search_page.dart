import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/ui/categories/categorie_page.dart';
import 'package:food_recipe_app/ui/detailpage/new_detail.dart';
import 'package:food_recipe_app/ui/favorite_page/favorite_list.dart';
import 'package:food_recipe_app/ui/homepage/categories_list.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/category_model.dart';
import '../../model/data_model.dart';
import '../../theme/color_primary.dart';
import '../homepage/home_page.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<CategoryModel> categories = [];

  getData() {
    for (var element in list_dataCategory) {
      categories.add(
          CategoryModel(
              cName: element['cName'],
              cUrl: element['cUrl'],
              cImage: element['cImage']
          )
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark
            ),
            leading: Builder(builder: (context) => IconButton(onPressed: (){
              Scaffold.of(context).openDrawer();
            }, icon: SizedBox(
                width: 35,
                child: IconButton(
                  icon: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 35
                  ),
                  onPressed: (){},
                )
            )
            )
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 70,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.black12,
              margin: EdgeInsets.all(20),
              child: TextField(
                onSubmitted: (value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListCategoriePage(name: value, url: 'https://api.edamam.com/api/recipes/v2?type=public&q=$value&app_id=bde2bc4a&app_key=1ae07909278fcf637b1a0392f992de7e'),));
                },
                style: TextStyle(
                  fontSize: 20
                ),
                decoration: InputDecoration(
                  fillColor: Colors.black38,
                  focusColor: Colors.black38,
                  enabledBorder: InputBorder.none,
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              )
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                top: 10,
                left: 10,
              ),
              child: Text('Categories'),
            ),
          ),
          SliverToBoxAdapter(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var data = categories[index];
                return Container(
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    hoverColor: Colors.white12,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListCategoriePage(name: data.cName, url: data.cUrl),));
                    },
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Image.asset(
                          data.cImage,
                          width: double.maxFinite,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF000000),
                                    Color(0x00000000)
                                  ]
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 14.0,
                            right: 14.0,
                            bottom: 14.0,
                            left: 14.0
                          ),
                          child: Text(
                            data.cName,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
