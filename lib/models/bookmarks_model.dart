import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_news_app/consts/sqflite_consts.dart';

class BookmarksModel with ChangeNotifier {
  String bookmarkKey,
      newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      publishedAt,
      dateToShow,
      content,
      readingTimeText;
  Uint8List? urlToImage;

  BookmarksModel({
    required this.bookmarkKey,
    required this.newsId,
    required this.sourceName,
    required this.authorName,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.dateToShow,
    required this.readingTimeText,
  });

  factory BookmarksModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    // String imgUrl = 'https://cdn-icons-png.flaticon.com/512/833/833268.png';
    // var res = await http.get(Uri.parse(imgUrl));
    // var bytes = res.bodyBytes;
    return BookmarksModel(
      bookmarkKey: json[SqfliteDbConstatnts.colBookmarkKey] ?? "",
      newsId: json[SqfliteDbConstatnts.colNewsId] ?? "",
      sourceName: json[SqfliteDbConstatnts.colSourceName] ?? "",
      authorName: json[SqfliteDbConstatnts.colAuthorName] ?? "",
      title: json[SqfliteDbConstatnts.colTitle] ?? "",
      description: json[SqfliteDbConstatnts.colDescription] ?? "",
      url: json[SqfliteDbConstatnts.colUrl] ?? '',
      urlToImage: json[SqfliteDbConstatnts.colUrlToImage] ?? "",
      publishedAt: json[SqfliteDbConstatnts.colPublishedAt] ?? '',
      dateToShow: json[SqfliteDbConstatnts.colDateToShow] ?? "",
      content: json[SqfliteDbConstatnts.colContent] ?? "",
      readingTimeText: json[SqfliteDbConstatnts.colReadingTimeText] ?? "",
    );
  }

  // static List<BookmarksModel> bookmarksFromSnapshot(
  //     {required dynamic json, required List allKeys}) {
  //   return allKeys.map((key) {
  //     return BookmarksModel.fromJson(json: json[key], bookmarkKey: key);
  //   }).toList();
  // }

//--
  Map<String, dynamic> toMap() {
    return {
      SqfliteDbConstatnts.colBookmarkKey: bookmarkKey,
      SqfliteDbConstatnts.colNewsId: newsId,
      SqfliteDbConstatnts.colSourceName: sourceName,
      SqfliteDbConstatnts.colAuthorName: authorName,
      SqfliteDbConstatnts.colTitle: title,
      SqfliteDbConstatnts.colDescription: description,
      SqfliteDbConstatnts.colUrl: url,
      SqfliteDbConstatnts.colUrlToImage: urlToImage,
      SqfliteDbConstatnts.colPublishedAt: publishedAt,
      SqfliteDbConstatnts.colDateToShow: dateToShow,
      SqfliteDbConstatnts.colContent: content,
      SqfliteDbConstatnts.colReadingTimeText: readingTimeText
    };
  }
}
