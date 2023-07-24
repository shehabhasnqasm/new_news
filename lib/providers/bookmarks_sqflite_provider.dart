import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_news_app/consts/sqflite_consts.dart';
import 'package:my_news_app/models/bookmarks_model.dart';
import 'package:my_news_app/models/news_model.dart';
import 'package:my_news_app/services/sqflite/crud_sqflite.dart';

class BookmarksProvider with ChangeNotifier {
  final BookMarkCrud bookMarkCrud;
  BookmarksProvider({required this.bookMarkCrud});
  List<BookmarksModel> bookmarkList = [];
  bool loading = false;
  bool dbIsExist = false;

  bool get isLoading {
    return loading;
  }

  List<BookmarksModel> get getBookmarkList {
    return bookmarkList;
  }

  Future<bool> isExist() async {
    try {
      loading = true;

      dbIsExist = await bookMarkCrud.isExistDatabase();
      loading = false;
      notifyListeners();

      return dbIsExist;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

//________________________ fetch all Bookmark items ( news that saved before ) __________
  Future<List<BookmarksModel>> fetchBookmarks() async {
    try {
      loading = true;
      // bookmarkList =
      //     await bookMarkCrud.getBookMarksList(SqfliteDbConstatnts.tableName);
      List<BookmarksModel> data =
          await bookMarkCrud.getBookMarksList(SqfliteDbConstatnts.tableName);
      bookmarkList = data.reversed.toList();

      loading = false;
      notifyListeners();

      return bookmarkList;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

//________________________ add item news to  Bookmark __________
  Future<void> addToBookmark({required NewsModel newsModel}) async {
    try {
      loading = true;
      int response = 0;
// var image = await get(
//   "https://images.pexels.com/photos/2047905/pexels-photo-2047905.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940");
// var bytes = image.bodyBytes;

      String imgUrl = newsModel.urlToImage;
      var res = await http.get(Uri.parse(imgUrl));
      var bytes = res.bodyBytes;
      print("============== bytes : $bytes");
      //var bytes = utf8.encode(res.bodyBytes);
      //var bytes = img.bodyBytes;

      BookmarksModel bookmarksModel;
      bookmarksModel = BookmarksModel(
          bookmarkKey: newsModel.bookmarkKey,
          newsId: newsModel.newsId,
          sourceName: newsModel.sourceName,
          authorName: newsModel.authorName,
          title: newsModel.title,
          description: newsModel.description,
          url: newsModel.url,
          urlToImage: bytes,
          publishedAt: newsModel.publishedAt,
          dateToShow: newsModel.dateToShow,
          content: newsModel.content,
          readingTimeText: newsModel.readingTimeText);
      response = await bookMarkCrud.insert(
          SqfliteDbConstatnts.tableName, bookmarksModel.toMap());
      print("response : $response");
      if (response > 0) {
        //insertSucceded = insertSucceded + 1;
      }

      log('Response : $response');
    } catch (error) {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

//________________________ delete item news from  Bookmark __________
  Future<void> deleteBookmark({required String whereArgs}) async {
    try {
      loading = true;
      int response = 0;
      response = await bookMarkCrud.delete(SqfliteDbConstatnts.tableName,
          '${SqfliteDbConstatnts.colBookmarkKey} = ?', [whereArgs]);

      log('Response deleted: $response');
      //log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

//________________________ delete sqflite database  (Bookmark) __________
  Future<void> deleteDataBase() async {
    try {
      await bookMarkCrud.deleteTheDatabase();
      notifyListeners();
      log('database deleted:');
      //log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    }
  }
//--------------------

}
