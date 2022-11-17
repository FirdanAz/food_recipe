import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_model.dart';


class MovieDatabase{
  static final MovieDatabase instance = MovieDatabase.init();

  static Database? _database;

  MovieDatabase.init();

  Future<Database> get database async{
    if (_database != null) return _database!;

    _database = await _initDB('food.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE $tableRecipe (
    ${FoodFields.id} $idType,
    ${FoodFields.name} $textType,
    ${FoodFields.imagePath} $textType,
    ${FoodFields.minute} $textType,
    ${FoodFields.calories} $textType,
    ${FoodFields.inx} $textType
    )''');
  }

  Future<FoodModel> create(FoodModel news) async{
    final db = await instance.database;

    final id = await db.insert(tableRecipe, news.toJson());
    return news.copy(id: id);
  }



  // Future<MovieModel> read(int? id) async{
  //   final db = await instance.database;
  //
  //   final maps = await db.query(
  //     tableMovie,
  //     columns: MovieFields.values,
  //     where: '${MovieFields.id} = ?',
  //     whereArgs: [id],
  //   );
  //
  //   if (maps.isNotEmpty){
  //     return MovieModel.fromJson(maps.first);
  //   } else {
  //     throw Exception('ID $id not found');
  //   }
  // }
  Future<FoodModel> read(String? title) async{
    final db = await instance.database;

    final maps = await db.query(
      tableRecipe,
      columns: FoodFields.values,
      where: '${FoodFields.name} = ?',
      whereArgs: [title],
    );

    if (maps.isNotEmpty){
      return FoodModel.fromJson(maps.first);
    } else {
      throw Exception('NAME $title not found');
    }
  }

  Future<List<FoodModel>> readAll() async{
    final db = await instance.database;

    final result = await db.query(tableRecipe);

    return result.map((json) => FoodModel.fromJson(json)).toList();
  }

  delete(String? title) async {
    final db = await instance.database;
    try {
      await db.delete(
        tableRecipe,
        where: '${FoodFields.name} = ?',
        whereArgs: [title],
      );
    } catch (e) {
      print(e);
    }
  }

  update(FoodModel movieModel) async {
    final db = await instance.database;
    try {
      db.rawUpdate('''
    UPDATE ${tableRecipe} 
    SET ${FoodFields.name} = ?, ${FoodFields.minute} = ?, ${FoodFields.imagePath} = ?, ${FoodFields.calories} = ?, ${FoodFields.inx} = ?
    WHERE ${FoodFields.id} = ?
    ''', [
        movieModel.name,
        movieModel.minute,
        movieModel.imagePath,
        movieModel.id
      ]);
    } catch (e) {
      print('error: ' + e.toString());
    }
  }


  Future close() async{
    final db = await instance.database;
    db.close();
  }
}