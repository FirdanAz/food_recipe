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

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key? key,required this.name, required this.url}) : super(key: key);
  String name;
  String url;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
            child: imageReady ? Container(
                child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.85,
                    crossAxisCount: 2),
                    physics: BouncingScrollPhysics(),
                    itemCount: recipeList.length,
                    itemBuilder: (context, index){
                      var data = recipeList[index];
                      return InkWell(
                          onTap: ()
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NewDetailPage(url: widget.url, index: index)
                                )
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2, color: Colors.black26),
                                            borderRadius: BorderRadius.all(Radius.circular(15))
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            bottom: 20
                                          ),
                                          child: Text(
                                            data.label,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(200)),
                                            child: SizedBox(
                                              height: 140,
                                              width: 140,
                                              child: Container(
                                                color: Colors.white,
                                              ),
                                            )
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                          child: SizedBox(
                                            height: 135,
                                            child: Image.network(
                                              data.image
                                            ),
                                          )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      );
                    }
                )
            ):const Center(child: Text('Loading...', style: TextStyle(fontSize: 20),),)
        ):const Center(child: Text('Loading...', style: TextStyle(fontSize: 20),),)
    );
  }
}
