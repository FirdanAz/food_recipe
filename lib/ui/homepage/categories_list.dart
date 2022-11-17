import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/ui/detailpage/new_detail.dart';

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
          backgroundColor: MyColor.primary,
          shadowColor: Colors.white,
          title: Text(widget.name, style: TextStyle(color: Colors.white),),
        ),
        body: _isLoad ? Container(
            child: imageReady ? Container(
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
                                MaterialPageRoute(builder: (context) => NewDetailPage(url: widget.url, index: index)
                                )
                            );
                          },
                          child: Card(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                      height: 140,
                                      child: imageReady ? Image.network(data.image,fit: BoxFit.cover,height: 140,width: 140,) : null
                                  ),
                                  Text(data.label, overflow: TextOverflow.clip,maxLines: 2,)
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
