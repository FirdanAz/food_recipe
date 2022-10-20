class RecipeModel {
  String image;
  String url;
  String source;
  String label;
  num time;
  List ingredients;

  RecipeModel({required this.image, required this.url, required this.source, required this.label,required this.time, required this.ingredients});
}