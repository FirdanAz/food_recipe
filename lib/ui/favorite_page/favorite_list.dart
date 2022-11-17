import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/theme/color_primary.dart';
import 'package:food_recipe_app/ui/detailpage/new_detail.dart';
import 'package:http/http.dart' as http;
import '../../model/favorite_database/database_model.dart';
import '../../model/favorite_database/favorite_database.dart';

class ListMoviePage extends StatefulWidget {
  const ListMoviePage({Key? key}) : super(key: key);

  @override
  State<ListMoviePage> createState() => _ListMoviePageState();
}

class _ListMoviePageState extends State<ListMoviePage> {
  List<FoodModel> dataListFood = [];
  bool isLoading = false;

  Future read() async {
    setState(() {
      isLoading = true;
    });
    dataListFood = await MovieDatabase.instance.readAll();
    print("Length List " + dataListFood.length.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  showDeleteDialog(BuildContext context, String? nama) {
    // set up the button
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Hapus"),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        await MovieDatabase.instance.delete(nama);
        read();
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Apakah anda yakin ingin menghapus?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Favorite',
          style: TextStyle(
              color: Colors.black45
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body:
      isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : dataListFood.length == 0 ? Center(child: Text("no data available"),) :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: dataListFood.length,
        itemBuilder: (c, index) {
          final item = dataListFood[index];
          var minute = num.parse(dataListFood[index].minute);
          if(minute == 0){
            minute = 45;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide(color: Colors.grey, width: 0.1))
              ),
              child: InkWell(
                onTap: () {
                  print(item.calories);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewDetailPage(url: item.calories, index: 1),));
                },
                onLongPress: (){
                  print(item.calories);
                  showDeleteDialog(context, item.name.toString());
                },
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    onTap: () async{
                      print(item.calories);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewDetailPage(url: item.calories, index: int.parse(item.inx)),));
                    },
                    leading: Container(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        (item.imagePath),
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
                    ),
                    title: Text(item.name, style: TextStyle(fontSize: 16, color: Colors.black),),
                    subtitle: Text('${minute} Minute', style: TextStyle(color: Colors.black45),),

                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
