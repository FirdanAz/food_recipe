import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.label, required this.ingredients}) : super(key: key);
  List ingredients = [];
  String? label;

  @override
  State<DetailPage> createState() => _DetaulPageState();
}

class _DetaulPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    int number = 0;
    return Scaffold(
      appBar: AppBar(title: Text(widget.label.toString()),),
      body: Container(
        child: ListView.builder(
        itemCount: widget.ingredients.length,
        itemBuilder: (context, i){
          var data = widget.ingredients[i];
          return SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${number = number +1} ',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                  Container(
                    width: 350,
                    child: Text(
                      data['text'],
                      style: TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.clip
                      ),
                    ),
                  ),
                ],
              )
          );
        }
        )
      ),
    );
  }
}
