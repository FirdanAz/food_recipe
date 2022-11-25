import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/model/detail_model.dart';
import 'package:food_recipe_app/ui/detailpage/detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../model/data_model.dart';
import '../../model/favorite_database/database_model.dart';
import '../../model/favorite_database/favorite_database.dart';
import '../../model/recipe_model.dart';
import '../../theme/color_primary.dart';

class NewDetailPage extends StatefulWidget {
  NewDetailPage({Key? key, required this.url, required this.index}) : super(key: key);
  String url;
  int index;

  @override
  State<NewDetailPage> createState() => _NewDetailPageState();
}

class _NewDetailPageState extends State<NewDetailPage> {
  List<RecipeModel> recipeList = [];
  bool _isLoad = false;
  bool isFavorit = false;
  FoodModel? foodModel;
  List<FoodModel> recipeList1 = [];
  bool imageReady = false;
  bool isLoading = false;

  Future read() async {
    setState(() {
      isLoading = true;
    });
    recipeList1 = await MovieDatabase.instance.readAll();
    print("Length List " + recipeList.length.toString());
    setState(() {
      isLoading = false;
    });
    for (var i = 0; i < recipeList1.length; i++) {
      if (recipeList1[i].name.toString() == recipeList[widget.index].label) {
        isFavorit = true;
      }
    }
  }

  getApi() async {

    var urll =
        widget.url;
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
    checkImageValidity();
    read();

  }

  checkImageValidity() async {
    var url = Uri.parse(recipeList[widget.index].image);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoad ? Scaffold(
      backgroundColor: Colors.white,
      body: imageReady ? ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: MyColor.white,
              pinned: true,
              floating: false,
              expandedHeight: 350,
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark
              ),
              leading: Padding(
                padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.6),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: MyColor.primary,size: 20,),
                    onPressed: (){
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ),
              actions: [
                IconButton(onPressed: () async {
                  setState(() {
                    isFavorit = !isFavorit;
                  });
                  if(isFavorit == true){
                    var food;
                    food = FoodModel(
                      imagePath: recipeList[widget.index].image,
                      name: recipeList[widget.index].label,
                      minute: recipeList[widget.index].time.toString(),
                      calories: widget.url,
                      inx: widget.index.toString()
                    );
                    await MovieDatabase.instance.create(food);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Color.fromARGB(255, 23, 23, 23),
                        duration: Duration(seconds: 1),
                        content: Row(
                          children: [
                            Icon(Icons.favorite,
                                color: Color.fromARGB(255, 213, 70, 70), size: 18),
                            SizedBox(width: 15),
                            Text("Ditambahkan ke Favorit"),
                          ],
                        )));
                  }else{
                    await MovieDatabase.instance.delete(recipeList[widget.index].label);
                  }
                }, icon: isFavorit ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border, color: Colors.white,)),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: <StretchMode>[
                  StretchMode.zoomBackground
                ],
                background: Stack(
                  children: [
                    Container(
                      height: 300,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(60),
                                bottomLeft: Radius.circular(60)
                            ),
                            child: InkWell(
                              onTap: () async {print(isFavorit);},
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    recipeList[widget.index].image,
                                    alignment: Alignment.center,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      // Appropriate logging or analytics, e.g.
                                      // myAnalytics.recordError(
                                      //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                                      //   exception,
                                      //   stackTrace,
                                      // );
                                      return const Icon(Icons.image_not_supported, color: MyColor.primary,);
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xD5000000),
                                              Color(0x00000000)
                                            ]
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(60),
                                bottomLeft: Radius.circular(60)
                            ),
                            child: Container(
                              height: 300,
                              color: MyColor.primary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(200)),
                                child: Container(
                                  height: 240,
                                  width: 240,
                                  color: MyColor.primary,
                                )
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(200)),
                              child: Image.network(
                                recipeList[widget.index].image,
                                height: 230,
                                errorBuilder:
                                    (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  // Appropriate logging or analytics, e.g.
                                  // myAnalytics.recordError(
                                  //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                                  //   exception,
                                  //   stackTrace,
                                  // );
                                  return const Icon(Icons.image_not_supported, color: MyColor.primary,);
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
            title(recipeList[widget.index].label, recipeList[widget.index].url, recipeList[widget.index].source),
            description(recipeList[widget.index].label, recipeList[widget.index].protein.toInt(), recipeList[widget.index].cholesterol.toInt(), recipeList[widget.index].calcium.toInt(), recipeList[widget.index].time.toInt(), recipeList[widget.index].ingredients.length),
            content(recipeList[widget.index].protein.toInt(), recipeList[widget.index].cholesterol.toInt(), recipeList[widget.index].calcium.toInt(), recipeList[widget.index].time.toInt()),
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(
                  left: 20,
                  top: 22,
                  right: 20,
                ),
                child: Text(
                  'Ingredients',
                  style: GoogleFonts.poppins(
                      color: MyColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            ingredients(recipeList[widget.index].ingredients, 0)
          ],
        ),
      ): Center(child: Icon(Icons.data_exploration_rounded, color: MyColor.primary,),)
    ): Center(child: Icon(Icons.data_exploration_rounded, color: MyColor.primary,),);
  }
}