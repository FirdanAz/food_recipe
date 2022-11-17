// import 'dart:math';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:food_recipe_app/model/favorite_database/database_model.dart';
// import 'package:food_recipe_app/theme/color_primary.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../model/favorite_database/favorite_database.dart';
//
// class DetailPage extends StatefulWidget {
//   DetailPage({Key? key,
//     required this.label,
//     required this.ingredients,
//     required this.image,
//     required this.minute,
//     required this.healthLabels,
//     required this.totalProtein,
//     required this.totalCholestrol,
//     required this.totalCalsium,
//     required this.source,
//     required this.urlSource,
//     required this.link
//   }) : super(key: key);
//   List ingredients = [];
//   String? label;
//   String? image;
//   num? minute;
//   List healthLabels = [];
//   num totalProtein;
//   num totalCholestrol;
//   num totalCalsium;
//   String source;
//   String urlSource;
//   String link;
//
//   @override
//   State<DetailPage> createState() => _DetaulPageState();
// }
//
// class _DetaulPageState extends State<DetailPage> {
//   bool isFavorit = false;
//   FoodModel? foodModel;
//   List<FoodModel> recipeList = [];
//   bool isLoading = false;
//
//   Future read() async {
//     setState(() {
//       isLoading = true;
//     });
//     recipeList = await MovieDatabase.instance.readAll();
//     print("Length List " + recipeList.length.toString());
//     setState(() {
//       isLoading = false;
//     });
//     for (var i = 0; i < recipeList.length; i++) {
//       if (recipeList[i].name.toString() == widget.label) {
//         isFavorit = true;
//       }
//     }
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     read();
//   }
//   @override
//   Widget build(BuildContext context) {
//     int protein = widget.totalProtein.toInt();
//     int cholestrol = widget.totalCholestrol.toInt();
//     int calsium = widget.totalCalsium.toInt();
//     int minute = widget.minute!.toInt();
//     int num = 0;
//     if(widget.minute == 0.0){
//       minute = 45;
//     }
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ScrollConfiguration(
//         behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             SliverAppBar(
//               backgroundColor: MyColor.white,
//               pinned: true,
//               floating: false,
//               expandedHeight: 350,
//               elevation: 0,
//               automaticallyImplyLeading: false,
//               leading: Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white.withOpacity(0.6),
//                   child: IconButton(
//                     icon: Icon(Icons.arrow_back, color: MyColor.primary,size: 20,),
//                     onPressed: (){
//                       Navigator.of(context).pop(true);
//                     },
//                   ),
//                 ),
//               ),
//               actions: [
//                 IconButton(onPressed: () async {
//                   setState(() {
//                     isFavorit = !isFavorit;
//                   });
//                   if(isFavorit == true){
//                     var food;
//                     food = FoodModel(
//                         imagePath: widget.image.toString(),
//                         name: widget.label.toString(),
//                       minute: widget.minute.toString(),
//                       calories: widget.link.toString(),
//                       inx: 1.toString()
//
//                     );
//                     await MovieDatabase.instance.create(food);
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         backgroundColor: Color.fromARGB(255, 23, 23, 23),
//                         duration: Duration(seconds: 1),
//                         content: Row(
//                           children: [
//                             Icon(Icons.favorite,
//                                 color: Color.fromARGB(255, 213, 70, 70), size: 18),
//                             SizedBox(width: 15),
//                             Text("Ditambahkan ke Favorit"),
//                           ],
//                         )));
//                   }else{
//                     await MovieDatabase.instance.delete(widget.label);
//                   }
//                 }, icon: isFavorit ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border, color: Colors.white,)),
//               ],
//               flexibleSpace: FlexibleSpaceBar(
//                 stretchModes: <StretchMode>[
//                   StretchMode.zoomBackground
//                 ],
//                 background: Stack(
//                   children: [
//                     Container(
//                       height: 300,
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(60),
//                                 bottomLeft: Radius.circular(60)
//                             ),
//                             child: InkWell(
//                               onTap: () async {print(isFavorit);},
//                               child: Stack(
//                                 fit: StackFit.expand,
//                                 children: [
//                                   Image.network(
//                                     widget.image.toString(),
//                                     alignment: Alignment.center,
//                                     filterQuality: FilterQuality.high,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               Color(0xD5000000),
//                                               Color(0x00000000)
//                                             ]
//                                         )
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           ClipRRect(
//                             borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(60),
//                                 bottomLeft: Radius.circular(60)
//                             ),
//                             child: Container(
//                               height: 300,
//                               color: MyColor.primary.withOpacity(0.7),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.bottomCenter,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.all(Radius.circular(200)),
//                             child: Container(
//                               height: 240,
//                               width: 240,
//                               color: MyColor.primary,
//                             )
//                           ),
//                           ClipRRect(
//                             borderRadius: BorderRadius.all(Radius.circular(200)),
//                             child: Image.network(
//                               widget.image.toString(),
//                               height: 230,
//                             ),
//                           ),
//                         ],
//                       )
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 alignment: Alignment.center,
//                 child: Text(
//                   widget.label.toString(),
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     color: Colors.black,
//                     fontSize: 25,
//                     fontWeight: FontWeight.w700
//                   ),
//                 )
//               )
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         width: 345,
//                         child: Text(
//                           '   this food is named ${widget.label}, it contains ingredients including, ${protein}g protein, ${cholestrol}g cholesterol, ${calsium}g calcium, it takes ${minute} minutes to make, and there is a ${widget.ingredients.length} ingredient for this meal.',
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 14,
//
//                           ),
//                           overflow: TextOverflow.clip,
//                           textAlign: TextAlign.justify,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 margin: EdgeInsets.only(
//                   top: 20,
//                   left: 20,
//                   right: 20
//                 ),
//                 alignment: Alignment.center,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: BorderDirectional(end: BorderSide(width: 2,color: Colors.black12)),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Column(
//                           children: [
//                             Text(
//                               protein.toString(),
//                               style: GoogleFonts.poppins(
//                                 color: MyColor.primary,
//                                 fontSize: 14
//                               ),
//                             ),
//                             Text(
//                               'Protein',
//                               style: GoogleFonts.poppins(
//                                 color: MyColor.primary,
//                                 fontSize: 12
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: BorderDirectional(end: BorderSide(width: 2,color: Colors.black12)),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Column(
//                           children: [
//                             Text(
//                               cholestrol.toString(),
//                               style: GoogleFonts.poppins(
//                                 color: MyColor.primary,
//                                 fontSize: 14
//                               ),
//                             ),
//                             Text(
//                               'Cholestrol',
//                               style: GoogleFonts.poppins(
//                                 color: MyColor.primary,
//                                 fontSize: 12
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: BorderDirectional(end: BorderSide(width: 2,color: Colors.black12)),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Column(
//                           children: [
//                             Text(
//                               calsium.toString(),
//                               style: GoogleFonts.poppins(
//                                 color: MyColor.primary,
//                                 fontSize: 14
//                               ),
//                             ),
//                             Text(
//                               'Calsium',
//                               style: GoogleFonts.poppins(
//                                 color: MyColor.primary,
//                                 fontSize: 12
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Column(
//                           children: [
//                             Text(
//                               minute.toString(),
//                               style: GoogleFonts.poppins(
//                                 color: MyColor.primary,
//                                 fontSize: 14
//                               ),
//                             ),
//                             Text(
//                               'Minute',
//                               style: GoogleFonts.poppins(
//                                 color: MyColor.primary,
//                                 fontSize: 12
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 alignment: Alignment.bottomLeft,
//                 margin: EdgeInsets.only(
//                   left: 20,
//                   top: 22,
//                   right: 20,
//                 ),
//                 child: Text(
//                   'Ingredients',
//                   style: GoogleFonts.poppins(
//                     color: MyColor.primary,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold
//                   ),
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 margin: EdgeInsets.only(
//                   left: 10,
//                   bottom: 10,
//                   right: 10
//                 ),
//                 child: ListView.builder(
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: widget.ingredients.length,
//                   itemBuilder: (context, index) {
//                     num = num + 1;
//                     var data = widget.ingredients[index];
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 60,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.all(Radius.circular(200)),
//                               child: Image.network(
//                                 data['image']
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   border: BorderDirectional(bottom: BorderSide(width: 1, color: Colors.black38))
//                                 ),
//                                 margin: EdgeInsets.only(
//                                   right: 10,
//                                   bottom: 18,
//                                   left: 18
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       margin: EdgeInsets.all(10),
//                                       child: Text(
//                                         '${num}',
//                                         style: GoogleFonts.poppins(
//                                           color: MyColor.primary,
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w600
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       margin: EdgeInsets.all(14),
//                                       width: 190,
//                                       child: Text(
//                                         data['text'],
//                                         maxLines: 2,
//                                         overflow: TextOverflow.clip,
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 12
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/color_primary.dart';

SliverToBoxAdapter ingredients(List ingredients,int num){
  return SliverToBoxAdapter(
    child: Container(
      margin: EdgeInsets.only(
          left: 10,
          bottom: 10,
          right: 10
      ),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          num = num + 1;
          var data = ingredients[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                    child: Image.network(
                        data['image']
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: BorderDirectional(bottom: BorderSide(width: 1, color: Colors.black38))
                      ),
                      margin: EdgeInsets.only(
                          right: 10,
                          bottom: 18,
                          left: 18
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              '${num}',
                              style: GoogleFonts.poppins(
                                  color: MyColor.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(14),
                            width: 190,
                            child: Text(
                              data['text'],
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 12
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    ),
  );
}
SliverToBoxAdapter title(String label, String url, String source) {
  return SliverToBoxAdapter(
      child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w700
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(Icons.link, color: MyColor.primary,),
                  InkWell(
                    child: Text(
                      ' $source',
                      style: GoogleFonts.poppins(
                        color: MyColor.primary,
                      ),
                    ),
                    onTap: () {
                      print(url);
                      launchUrl(Uri.parse(
                          url
                      ));
                    },
                  ),
                ],
              )
            ],
          )
      )
  );
}
SliverToBoxAdapter description(String label, int protein, int cholestrol, int calcium, int time, int ingredients) {
  var minute = time;
  if(minute == 0){
    minute = 45;
  }
  return SliverToBoxAdapter(
    child: Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 345,
              child: Text(
                '   this food is named ${label},'
                    ' it contains ingredients including,'
                    ' ${protein}g protein,'
                    ' ${cholestrol}g cholesterol, '
                    '${calcium}g calcium,'
                    ' it takes ${minute} minutes to make, and there is a '
                    '${ingredients} ingredient for this meal.',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.justify,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
SliverToBoxAdapter content(int protein,int  cholestrol, int calsium, int time){
  var minute = time;
  if(minute == 0){
    minute = 45;
  }
  return SliverToBoxAdapter(
    child: Container(
      margin: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: BorderDirectional(end: BorderSide(width: 2,color: Colors.black12)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    protein.toInt().toString(),
                    style: GoogleFonts.poppins(
                        color: MyColor.primary,
                        fontSize: 14
                    ),
                  ),
                  Text(
                    'Protein',
                    style: GoogleFonts.poppins(
                        color: MyColor.primary,
                        fontSize: 12
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: BorderDirectional(end: BorderSide(width: 2,color: Colors.black12)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    cholestrol.toInt().toString(),
                    style: GoogleFonts.poppins(
                        color: MyColor.primary,
                        fontSize: 14
                    ),
                  ),
                  Text(
                    'Cholestrol',
                    style: GoogleFonts.poppins(
                        color: MyColor.primary,
                        fontSize: 12
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: BorderDirectional(end: BorderSide(width: 2,color: Colors.black12)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    calsium.toInt().toString(),
                    style: GoogleFonts.poppins(
                        color: MyColor.primary,
                        fontSize: 14
                    ),
                  ),
                  Text(
                    'Calsium',
                    style: GoogleFonts.poppins(
                        color: MyColor.primary,
                        fontSize: 12
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    minute.toInt().toString(),
                    style: GoogleFonts.poppins(
                        color: MyColor.primary,
                        fontSize: 14
                    ),
                  ),
                  Text(
                    'Minute',
                    style: GoogleFonts.poppins(
                        color: MyColor.primary,
                        fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
