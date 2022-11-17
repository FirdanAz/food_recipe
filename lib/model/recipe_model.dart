class RecipeModel {
  String image;
  String url;
  String source;
  String label;
  num time;
  List ingredients;
  List cuisineType;
  List healthLabels;
  num protein;
  num cholesterol;
  num calcium;
  String link;

  RecipeModel(
      {
        required this.image,
        required this.url,
        required this.source,
        required this.label,
        required this.time,
        required this.ingredients,
        required this.cuisineType,
        required this.healthLabels,
        required this.protein,
        required this.cholesterol,
        required this.calcium,
        required this.link
      }
  );
}