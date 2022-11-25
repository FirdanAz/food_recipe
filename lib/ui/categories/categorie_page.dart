import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/ui/detailpage/new_detail.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/recipe_model.dart';
import 'package:http/http.dart' as http;

import '../../theme/color_primary.dart';
import '../detailpage/detail.dart';
import '../homepage/home_page.dart';

class ListCategoriePage extends StatefulWidget {
  ListCategoriePage({Key? key,required this.name, required this.url}) : super(key: key);
  String name;
  String url;

  @override
  State<ListCategoriePage> createState() => _ListCategoriePageState();
}

class _ListCategoriePageState extends State<ListCategoriePage> {
  List<RecipeModel> recipeList = [];
  bool _isLoad = false;
  bool imageReady = false;

  getApi() async {
    var urll = widget.url;
    var response = await http.get(Uri.parse(urll));
    Map json = jsonDecode(response.body);
    json['hits'].forEach((e){
      RecipeModel recipeModel = RecipeModel(
          image: e['recipe']['image'],
          url: e['recipe']['url'],
          source: e['recipe']['source'],
          label: e['recipe']['label'],
          time: e['recipe']['totalTime'],
          ingredients: e['recipe']['ingredients'],
          cuisineType: e['recipe']['dietLabels'],
          healthLabels: e['recipe']['healthLabels'],
          protein: e['recipe']['totalDaily']['PROCNT']['quantity'],
          cholesterol: e['recipe']['totalDaily']['CHOLE']['quantity'],
          calcium: e['recipe']['totalDaily']['CA']['quantity'],
          link: e['_links']['self']['href']
      );
      print(recipeModel);
      setState(() {
        recipeList.add(recipeModel);
        _isLoad = true;
      });
    });
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Text(widget.name, style: TextStyle(color: MyColor.primary),),
          leading: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.6),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: MyColor.primary,size: 20,),
              onPressed: (){
                Navigator.of(context).pop(true);
              },
            ),
          ),
        ),
        body: _isLoad ? Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              if(recipeList[index].cuisineType.length > 1)
                recipeList[index].cuisineType.length = 1;
              if(recipeList[index].cuisineType.length < 1)
                recipeList[index].cuisineType.length = 0;
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
                        MaterialPageRoute(builder: (context) => NewDetailPage(url: widget.url, index: index))
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
                                        physics: NeverScrollableScrollPhysics(),
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
          ),
        ):popularLoading()
    );
  }
}
