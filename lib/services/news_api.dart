import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:news_app_flutter_course/consts/http_exceptions.dart';
// import 'package:news_app_flutter_course/models/bookmarks_model.dart';
// import 'package:news_app_flutter_course/models/news_model.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_news_app/consts/api_consts.dart';
import 'package:my_news_app/consts/http_exceptions.dart';
import 'package:my_news_app/models/news_model.dart';

//import '../consts/api_consts.dart';

class NewsAPiServices {
  static Future<List<NewsModel>> getAllNews(
      {required int page,
      required String sortBy,
      required String category}) async {
    //apiKey =883128b553334e2aa7c1ed79245af8c4
    // var url = Uri.parse(
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=883128b553334e2aa7c1ed79245af8c4');

    //GET https://newsapi.org/v2/top-headlines/sources?category=business&apiKey=883128b553334e2aa7c1ed79245af8c4

    try {
      var uri = Uri.https(BASEURL, "v2/everything", {
        "q": category, //"apple",
        "pageSize": "10",
        "language": "en",
        // "domains": "techcrunch.com",
        "page": page.toString(),
        "sortBy": sortBy
        // "apiKEY": API_KEY
      });
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      // log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data["articles"].length.toString());

      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: "Sorry , please check your internet !.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception(e.toString());
    } on HttpException catch (err) {
      Fluttertoast.showToast(
          msg: "Sorry !, an Unknoun error happen| $err",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception(err.toString());
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Sorry !, an Unknoun error happen$error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception(error.toString());
    }
  }

  static Future<List<NewsModel>> getTopHeadlines(String category) async {
    try {
      // var uri = Uri.https(BASEURL, "v2/top-headlines", {'country': 'us' });
      var uri = Uri.https(
          BASEURL, "v2/top-headlines", {'country': 'us', 'category': category});
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data["articles"].length.toString());

      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: "Sorry , please check your internet !.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception(e.toString());
    } on HttpException catch (err) {
      Fluttertoast.showToast(
          msg: "Sorry !, an Unknoun error happen|$err",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception(err.toString());
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Sorry !, an Unknoun error happen|$error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception(error.toString());
    }
  }

  static Future<List<NewsModel>> searchNews({required String query}) async {
    try {
      var uri = Uri.https(BASEURL, "v2/everything", {
        "q": query,
        "pageSize": "10",
        "domains": "techcrunch.com",
      });
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      // log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data["articles"].length.toString());

      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: "Sorry , please check your internet !.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception(e.toString());
    } on HttpException catch (err) {
      Fluttertoast.showToast(
          msg: "Sorry !, an Unknoun error happen|$err",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception(err.toString());
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Sorry !, an Unknoun error happen|$error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception(error.toString());
    }
  }
}
