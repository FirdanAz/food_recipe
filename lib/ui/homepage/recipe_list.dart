import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/model/recipe_model.dart';
import 'package:food_recipe_app/ui/detailpage/detail.dart';
import 'package:http/http.dart' as http;

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<RecipeModel> recipeList = [];
  bool _isLoad = false;

  getApi() async {
    const urll =
        'https://api.edamam.com/api/recipes/v2?type=public&q=chicken&app_id=bde2bc4a&app_key=1ae07909278fcf637b1a0392f992de7e';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Food Recipe', style: TextStyle(color: Colors.black),),
      ),
      body: _isLoad ? Container(
        child: Container(
          child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
              itemCount: recipeList.length,
              itemBuilder: (context, index){
              var data = recipeList[index];
                return InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailPage(label: data.label.toString(), ingredients: data.ingredients.toList())));
                  },
                  child: _isLoad ? Card(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                              child: Image.network(data.image,fit: BoxFit.cover,)
                          ),
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
