import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _food = [];
  List<String> get food => _food;

  void toggleFavorite(String food){
    final isExist = _food.contains(food);
    if(isExist) {
      _food.remove(food);
    }else {
      _food.add(food);
    }
    notifyListeners();
  }

  bool isExist(String food) {
    final isExist = _food.contains(food);
    return isExist;
  }

  void clearFavorite() {
    _food = [];
    notifyListeners();
  }
}