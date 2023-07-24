import 'package:flutter/material.dart';
import 'package:my_news_app/models/news_model.dart';
import 'package:my_news_app/services/news_api.dart';

class NewsProvider with ChangeNotifier {
  List<NewsModel> newsList = [];

  List<NewsModel> get getNewsList {
    return newsList;
  }

  Future<List<NewsModel>> fetchAllNews(
      {required int pageIndex,
      required String sortBy,
      required String category}) async {
    newsList = await NewsAPiServices.getAllNews(
        page: pageIndex, sortBy: sortBy, category: category);
    return newsList;
  }

  Future<List<NewsModel>> fetchTopHeadlines(String category) async {
    newsList = await NewsAPiServices.getTopHeadlines(category);
    return newsList;
  }

  Future<List<NewsModel>> searchNewsProvider({required String query}) async {
    newsList = await NewsAPiServices.searchNews(query: query);
    return newsList;
  }

  NewsModel findByDate({required String? publishedAt}) {
    return newsList
        .firstWhere((newsModel) => newsModel.publishedAt == publishedAt);
  }
}
