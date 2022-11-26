import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/model/category_model.dart';
import 'package:food_recipe_app/model/favorite_database/database_model.dart';
import 'package:food_recipe_app/theme/color_primary.dart';
import 'package:food_recipe_app/ui/categories/categorie_page.dart';
import 'package:food_recipe_app/ui/detailpage/detail.dart';
import 'package:food_recipe_app/ui/detailpage/new_detail.dart';
import 'package:food_recipe_app/ui/homepage/categories_list.dart';
import 'package:food_recipe_app/ui/homepage/search_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../../model/data_model.dart';
import '../../model/recipe_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String urlLink = 'https://api.edamam.com/api/recipes/v2?type=public&q=rocket pizza&app_id=bde2bc4a&app_key=1ae07909278fcf637b1a0392f992de7e';
  List<RecipeModel> recipeList = [];
  bool _isLoad = false;
  List<CategoryModel> categories = [];
  bool isFavorit = false;
  List<FoodModel> dataListFood = [];
  bool imageReady = false;

  getApi() async {
    for (var i =0;i<dataListFood.length; i++) {
      if (dataListFood[i].name == recipeList[i].label) {
        isFavorit = true;
      }
    }

    var urll =
        urlLink;
    var response = await http.get(Uri.parse(urll));
    Map json = jsonDecode(response.body);
    json['hits'].forEach((e){
      RecipeModel recipeModel = RecipeModel(
        image: e['recipe']['images']['REGULAR']['url'],
        url: e['recipe']['url'],
        source: e['recipe']['source'],
        label: e['recipe']['label'],
        time: e['recipe']['totalTime'],
        ingredients: e['recipe']['ingredients'],
        cuisineType: e['recipe']['cuisineType'],
        healthLabels: e['recipe']['healthLabels'],
        protein: e['recipe']['totalDaily']['PROCNT']['quantity'],
        cholesterol: e['recipe']['totalDaily']['CHOLE']['quantity'],
        calcium: e['recipe']['totalDaily']['CA']['quantity'],
        link: e['_links']['self']['href']
      );
      setState(() {
        recipeList.add(recipeModel);
        _isLoad = true;
      });
    });
    for (var element in data_category) {
      categories.add(
          CategoryModel(
              cName: element['cName'],
              cUrl: element['cUrl'],
              cImage: element['cImage']
          )
      );
    }
    checkImageValidity();
  }

  checkImageValidity() async {
    for(int i = 0; i<recipeList.length; i++){
      var url = Uri.parse(recipeList[i].image);
      http.Response response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          setState(() {
            imageReady = true; // It's valid
          });
        }
      } catch (e) {
        // TODO nothing special to do here
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          shadowColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: (){
                Scaffold.of(context).openDrawer();
              }, icon: SizedBox(
                  width: 35,
                  child: IconButton(
                    icon: Icon(
                      Icons.search_sharp,
                      color: MyColor.white,
                      size: 35
                    ),
                    onPressed: (){
                      showSearch(
                        context: context,
                        delegate: CustomSearch()
                      );
                    },
                  )
              )
              ),
            )
          ],
          leading: Builder(builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){
              Scaffold.of(context).openDrawer();
            }, icon: const SizedBox(
              width: 35,
              child: Icon(
                Icons.person,
                color: MyColor.white,
                size: 35
              )
              )
            ),
          )),
        ),
        body: ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)
                  ),
                  child: Container(
                    height: 250,
                    color: MyColor.primary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: 30,
                            left: 10
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Recipe',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    color: MyColor.white
                                  ),
                                ),
                                Text(
                                  ' - Food',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: MyColor.white
                                  ),
                                ),
                                Text(
                                  ' - App',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: MyColor.white
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "it's time to get creative!",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: MyColor.white
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 40
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Categories',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: MyColor.white
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'View All',
                                      style: GoogleFonts.poppins(
                                          color: MyColor.primary.withOpacity(0.8),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: _isLoad ? SizedBox(
                                height: 200,
                                child: ScrollConfiguration(
                                  behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categories.length,
                                    itemBuilder: (context, index) {
                                      var data = categories[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ListCategoriePage(url: data.cUrl, name: data.cName),)
                                          );
                                        },
                                        child: Card(
                                          // color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.5),
                                          elevation: 2,
                                          shadowColor: Colors.black,
                                          child: SizedBox(
                                            width: 130,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(data.cImage),
                                                ),
                                                Center(
                                                  child: Text(
                                                    data.cName,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ): categoriesLoading()
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 40
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Popular',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    ' - Food',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: MyColor.primary
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: _isLoad ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            var minute = recipeList[index].time;
                            if(minute == 0){
                              minute = 45;
                            }
                            var data = recipeList[index];
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NewDetailPage(url: urlLink, index: index))
                                  );
                                },
                                child: Card(
                                  // color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.5),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    height: 120,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: imageReady ? Container(
                                                color: Colors.transparent,
                                                child: ClipRRect(
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      bottomLeft: Radius.circular(10),
                                                    ),
                                                    child: Image.network(data.image, errorBuilder:
                                                        (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                      // Appropriate logging or analytics, e.g.
                                                      // myAnalytics.recordError(
                                                      //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                                                      //   exception,
                                                      //   stackTrace,
                                                      // );
                                                      return Center(child: imagePopular());
                                                    },
                                                    ),
                                                ),
                                              ): imagePopular()
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      alignment: Alignment.topLeft,
                                                      width: 200,
                                                      child: Text(
                                                        data.label,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.clip,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.topLeft,
                                                    width: 200,
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.timer,
                                                          size: 17,
                                                          color: MyColor.primary,
                                                        ),
                                                        Text(
                                                          ' $minute Minutes',
                                                          overflow: TextOverflow.clip,
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500,
                                                              color: MyColor.primary
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.topLeft,
                                                    width: 200,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: data.cuisineType.length,
                                                      itemBuilder: (context, index) {
                                                        var cuisineType = data.cuisineType[index];
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            const Icon(
                                                              Icons.fastfood,
                                                              size: 17,
                                                              color: MyColor.primary,
                                                            ),
                                                            Container(
                                                              width: 170,
                                                              child: Text(
                                                                ' $cuisineType',
                                                                maxLines: 1,
                                                                overflow: TextOverflow.clip,
                                                                style: GoogleFonts.poppins(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: MyColor.primary.withOpacity(0.8)
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 30,
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(3),
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.transparent,
                                            onPressed: () async {},
                                            elevation: 0,
                                            child: Icon(Icons.navigate_next, color: MyColor.primary,),
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ):popularLoading()
                      )
                    ],
                  )
                ),
              ],
            )
          ),
        ),
      )
    );
  }
}

class CustomSearch extends SearchDelegate {
  List allData = [
    'Chicken',
    'Pizza',
    'Noodle',
    'Seafood',
    'Salad'
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: (){
            query = '';
          },
          icon: Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      },
      icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchPage(name: query, url: 'https://api.edamam.com/api/recipes/v2?type=public&q=$query&app_id=bde2bc4a&app_key=1ae07909278fcf637b1a0392f992de7e');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for(var item in allData) {
      if(item.toString().toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item.toString());
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          onTap: (){
            query = result;
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListCategoriePage(name: result, url: 'https://api.edamam.com/api/recipes/v2?type=public&q=$result&app_id=bde2bc4a&app_key=1ae07909278fcf637b1a0392f992de7e');
            },));
          },
          title: Text(
              result
          ),
        );
      },
    );
  }

}
Shimmer? categoriesLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: SizedBox(
      height: 200,
      child: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            return InkWell(
              child: Card(
                // color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.5),
                elevation: 2,
                shadowColor: Colors.black,
                child: SizedBox(
                  width: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.white,
                          )
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            '',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
Shimmer? imagePopular(){
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
    child: Container(
      color: Colors.white,
      child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10)
          ),
      ),
    ),
  );
}
Shimmer? popularLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: (){
            },
            child: Card(
              // color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.5),
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(5),
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)
                            ),
                            child: Container(child: SizedBox())
                        ),
                        Container(
                          color: Colors.white,
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  width: 160,
                                  child: Text(
                                    '',
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                width: 160,
                                child: Text(
                                  '',
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.7)
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                width: 160,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      color: Colors.white,
                                      child: Text(
                                        '',
                                        overflow: TextOverflow.clip,
                                        style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: MyColor.primary.withOpacity(0.8)
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.all(10),
                      child: IconButton(
                        onPressed: () async{
                        },
                        icon: Icon(Icons.favorite)
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    )
  );
}
backGround(){
  return SizedBox(
    width: double.maxFinite,
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
          ),
          child: Container(
            height: 300,
            width: double.maxFinite,
            color: MyColor.primary,
          ),
        ),
        Container(
          color: Colors.white,
          width: double.maxFinite,
        )
      ],
    ),
  );
}
