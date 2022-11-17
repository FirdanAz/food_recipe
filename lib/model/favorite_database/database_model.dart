final String tableRecipe = 'news';

class FoodFields {
  static final List<String> values = [
    id, imagePath, name, minute, calories, inx
  ];
  static final String id = '_id';
  static final String imagePath = 'img';
  static final String name = 'name';
  static final String minute = 'minute';
  static final String calories = 'calories';
  static final String inx = 'inx';
}

class FoodModel {
  final int? id;
  final String imagePath;
  final String name;
  final String minute;
  final String calories;
  final String inx;

  FoodModel(
      {this.id,
        required this.imagePath,
        required this.name,
        required this.minute,
        required this.calories,
        required this.inx
      });

  static FoodModel fromJson(Map<String, Object?> json) => FoodModel(
      id: json[FoodFields.id] as int?,
      minute: json[FoodFields.minute] as String,
      name: json[FoodFields.name] as String,
      imagePath: json[FoodFields.imagePath] as String,
      calories: json[FoodFields.calories] as String,
      inx: json[FoodFields.inx] as String
  );

  Map<String, Object?> toJson() => {
    FoodFields.id: id,
    FoodFields.minute: minute,
    FoodFields.name: name,
    FoodFields.imagePath: imagePath,
    FoodFields.calories: calories,
    FoodFields.inx: inx
  };
  FoodModel copy({int? id, String? minutes, String? author, String? imageUrl, String? calorie, String? indx}) =>
      FoodModel(
          id: id ?? this.id,
          minute: minutes ?? this.minute,
          name: author ?? this.name,
          imagePath: imageUrl ?? this.imagePath,
          calories: calorie ?? this.calories,
          inx: indx ?? inx
      );
}
