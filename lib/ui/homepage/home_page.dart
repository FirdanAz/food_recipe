import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/theme/color_primary.dart';
import 'package:food_recipe_app/ui/bottom_nav/bottom_navigation.dart';
import 'package:food_recipe_app/ui/homepage/sidebar/side_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../model/recipe_model.dart';
import '../detailpage/detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> recipeList = [];
  bool _isLoad = false;

  getApi() async {
    const urll =
        'https://api.edamam.com/api/recipes/v2?type=public&q=salad&app_id=bde2bc4a&app_key=1ae07909278fcf637b1a0392f992de7e';
    var response = await http.get(Uri.parse(urll));
    Map json = jsonDecode(response.body);
    json['hits'].forEach((e){
      RecipeModel recipeModel = RecipeModel(
          image: e['recipe']['image'],
          url: e['recipe']['url'],
          source: e['recipe']['source'],
          label: e['recipe']['label'],
          time: e['recipe']['totalTime'],
          ingredients: e['recipe']['ingredients']
      );
      print(recipeModel);
      setState(() {
        recipeList.add(recipeModel);
        _isLoad = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideBar(),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: false,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            expandedHeight: 150,
            leading: Builder(builder: (context) => IconButton(onPressed: (){
              Scaffold.of(context).openDrawer();
            }, icon: SizedBox(
              width: 35,
              child: Image.asset(
                'assets/icon/menu_icon.png',
                color: MyColor.orange,
              ),
            )
            )),
            shadowColor: Colors.transparent,
            actions: [
              IconButton(
                  onPressed: (){},
                  icon: const Icon(
                    Icons.search,
                    color: MyColor.orange,
                    size: 35,
                  )
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                  'Mam, what are you cooking today?',
                  style: GoogleFonts.poppins(
                    color: MyColor.orange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600
                  )
              )
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 40,
                left: 15,
                bottom: 10
              ),
              child: Text(
                'Popular',
                style: TextStyle(
                  color: MyColor.orange,
                  fontSize: 17,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 240,
              child: Container(
                margin: EdgeInsets.only(left: 12),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: recipeList.length,
                  itemBuilder: (context, index) {
                    var data = recipeList[index];
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),

                        ),
                        child: InkWell(
                          onTap: (){},
                          child: Card(
                            elevation: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      width: 140.0,
                                      child: Image.network(data.image, fit: BoxFit.cover,),
                                    ),
                                    SizedBox(
                                      width: 140,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            data.label,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12
                                            ),
                                          ),
                                        )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        data.source,
                                        style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          color: MyColor.orange
                                        )
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30,
                  left: 15,
                  bottom: 10
              ),
              child: Text(
                'Latest',
                style: TextStyle(
                    color: MyColor.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index){
                var data = recipeList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 5,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.network(data.image, fit: BoxFit.cover, height: 160, width: 140,)
                                ),
                                Container(
                                  width: 200,
                                  margin: EdgeInsets.only(top: 10),
                                  alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        data.label,
                                        overflow: TextOverflow.clip,
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context).textTheme.headline4,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87.withOpacity(0.8)
                                        ),
                                      ),
                                    )
                                )
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: recipeList.length)
          )
        ],
      ),
    );
  }
}
