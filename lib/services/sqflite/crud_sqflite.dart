import 'package:flutter/material.dart';
import 'package:my_news_app/consts/sqflite_consts.dart';
import 'package:my_news_app/models/bookmarks_model.dart';
import 'package:my_news_app/services/sqflite/db_sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookMarkCrud {
  SqfliteDB sqfliteDB;
  BookMarkCrud({required this.sqfliteDB});
  List<BookmarksModel> bookMarksList = [];

  Future<List<BookmarksModel>> getBookMarksList(String tableName) async {
    bookMarksList = [];
    Database? dataBase = await sqfliteDB.db;
    List<Map<String, Object?>> response = await dataBase!.query(tableName);

    for (int i = 0; i < response.length; i++) {
      bookMarksList.add(BookmarksModel.fromJson(json: response[i]));
    }
    return bookMarksList;
  }

  Future<int> insert(
    String tableName,
    Map<String, Object?> values,
  ) async {
    Database? dataBase = await sqfliteDB.db;
    int response = await dataBase!
        .insert(tableName, values, conflictAlgorithm: ConflictAlgorithm.ignore);
    return response;
  }

  Future<int> delete(
      String tableName, String? where, List<Object?>? whereArgs) async {
    Database? dataBase = await sqfliteDB.db;
    int response =
        await dataBase!.delete(tableName, where: where, whereArgs: whereArgs);
    return response;
  }

  deleteTheDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, SqfliteDbConstatnts.dbName);
    bool exist = await databaseExists(path);
    if (exist == true) {
      await deleteDatabase(path);
      print("exist =>$exist ,,, db deleted");
    }
    print("exist =>$exist ,,, ");
  }

  Future<bool> isExistDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, SqfliteDbConstatnts.dbName);
    bool exist = await databaseExists(path);
    if (exist == true) {
      return true;
    } else {
      return false;
    }
   
  }

/*
  Future<int> update(
      String tableName, Map<String, Object?> values, String? where) async {
    Database? dataBase = await sqfliteDB.db;
    int response = await dataBase!.update(tableName, values, where: where);
    return response;
  }

  Future<int> delete(
      String tableName, String? where, List<Object?>? whereArgs) async {
    Database? dataBase = await sqfliteDB.db;
    int response =
        await dataBase!.delete(tableName, where: where, whereArgs: whereArgs);
    return response;
  }

  deleteTheDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'historydb.db');
    bool exist = await databaseExists(path);
    if (exist == true) {
      await deleteDatabase(path);
      print("exist =>$exist ,,, db deleted");
    }
    print("exist =>$exist ,,, ");
  }

  */
}
