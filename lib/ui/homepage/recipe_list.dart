import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/model/recipe_model.dart';
import 'package:food_recipe_app/theme/color_primary.dart';
import 'package:food_recipe_app/ui/detailpage/detail.dart';
import 'package:food_recipe_app/ui/detailpage/new_detail.dart';
import 'package:http/http.dart' as http;

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<RecipeModel> recipeList = [];
  bool _isLoad = false;
  bool imageReady = false;
  String urlLink = 'https://api.edamam.com/api/recipes/v2?type=public&q=chicken&app_id=bde2bc4a&app_key=1ae07909278fcf637b1a0392f992de7e';

  getApi() async {
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
        backgroundColor: MyColor.primary,
        title: const Text('Food Recipe', style: TextStyle(color: Colors.white),),
      ),
      body: _isLoad ? Container(
        child: Container(
          child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
              itemCount: recipeList.length,
              itemBuilder: (context, index){
              var data = recipeList[index];
                return InkWell(
                onTap: ()
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewDetailPage(url: urlLink, index: index)
                      )
                  );
                },
                  child: _isLoad ? Card(
                    child: Container(
                      child: Column(
                        children: [
                          imageReady ? Container(
                            height: 150,
                              child: Image.network(data.image,fit: BoxFit.cover,)
                          ):Icon(Icons.print),
                          Text(data.label)
                        ],
                      ),
                    ),
                  ): CircularProgressIndicator()
                );
              }
          )
        )
      ):const Center(child: Text('Loading...', style: TextStyle(fontSize: 20),),)
    );
  }
}
