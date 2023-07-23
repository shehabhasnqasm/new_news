import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// import 'package:news_app_flutter_course/models/bookmarks_model.dart';
// import 'package:news_app_flutter_course/providers/bookmarks_provider.dart';
// import 'package:news_app_flutter_course/widgets/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_news_app/consts/styles.dart';
import 'package:my_news_app/models/bookmarks_model.dart';
import 'package:my_news_app/models/news_model.dart';
import 'package:my_news_app/providers/bookmarks_sqflite_provider.dart';
import 'package:my_news_app/services/global_methods.dart';
import 'package:my_news_app/services/utils.dart';
import 'package:my_news_app/widgets/utils/utils_widget/loader.dart';
import 'package:my_news_app/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

// import '../consts/styles.dart';
// import '../providers/news_provider.dart';
// import '../services/global_methods.dart';
// import '../services/utils.dart';

class NewsDetailsScreen extends StatefulWidget {
  //  const NewsDetailsScreen({Key? key}) : super(key: key);

  ////
  //static const routeName = "/NewsDetailsScreen";
  const NewsDetailsScreen(
      {Key? key, required this.newsModel, required this.tag})
      : super(key: key);

  final NewsModel newsModel;
  final String tag;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool isInBookmark = false;
  // String? publishedAt;
  // var data;
  // // int? index;
  List<BookmarksModel> currBookmarkList = [];
  List<BookmarksModel> bookmarkList = [];
  bool loader = false;

  @override
  void initState() {
    super.initState();

    isInBookmark = true;
    // String? publishedAt;
    // var data;
    // // int? index;
    currBookmarkList = [];
    bookmarkList = [];
    print("initstate-------------------------");
    startb();
    // onPressedFun();
    // final bookmarksProvider =
    //     Provider.of<BookmarksProvider>(context, listen: false);
    //  bookmarksProvider.fetchBookmarks();
    // bookmarkList = bookmarksProvider.getBookmarkList;
    // // bookmarkList =
    // //     Provider.of<BookmarksProvider>(context, listen: false).getBookmarkList;
    // if (bookmarkList.isEmpty) {
    //   isInBookmark = false;
    // } else {
    //   markedfun();
    // }
    // // markedfun();
  }

  // @override
  // void didChangeDependencies() {
  //   // publishedAt = ModalRoute.of(context)!.settings.arguments as String;

  //   // index = ModalRoute.of(context)!.settings.arguments as int;
  //   final bookmarksProvider = Provider.of<BookmarksProvider>(context);
  //   bookmarksProvider.fetchBookmarks();
  //   bookmarkList = bookmarksProvider.getBookmarkList;
  //   // bookmarkList =
  //   //     Provider.of<BookmarksProvider>(context, listen: false).getBookmarkList;
  //   if (bookmarkList.isEmpty) {
  //     return;
  //   }
  //   markedfun();
  //   // if (currBookmarkList.isEmpty) {
  //   //   isInBookmark = false;
  //   // } else {
  //   //   isInBookmark = true;
  //   // }
  //   super.didChangeDependencies();
  // }

  markedfun() async {
    currBookmarkList = [];
    currBookmarkList = bookmarkList
        .where((element) => element.bookmarkKey == widget.newsModel.bookmarkKey)
        .toList();

    if (currBookmarkList.isEmpty) {
      isInBookmark = false;
      print(
          "currBookmarkList.isEmpty in markedfun ;  isInBookmark is false : $isInBookmark;");
    } else if (currBookmarkList.isNotEmpty) {
      isInBookmark = true;
      print(
          "currBookmarkList.isNotEmpty in markedfun ;  isInBookmark is true : $isInBookmark;");
    }
  }

  Future<void> startb() async {
    loader = true;
    final bookmarksProvider =
        Provider.of<BookmarksProvider>(context, listen: false);
    bookmarkList = await bookmarksProvider.fetchBookmarks();
    //bookmarkList = bookmarksProvider.getBookmarkList;
    // bookmarkList =
    //     Provider.of<BookmarksProvider>(context, listen: false).getBookmarkList;
    if (bookmarkList.isEmpty) {
      isInBookmark = false;
    } else if (bookmarkList.isNotEmpty) {
      // markedfun();

      currBookmarkList = [];
      currBookmarkList = bookmarkList
          .where(
              (element) => element.publishedAt == widget.newsModel.publishedAt)
          .toList();
      if (currBookmarkList.isEmpty) {
        isInBookmark = false;
        print(
            "currBookmarkList.isEmpty in markedfun ;  isInBookmark is false : $isInBookmark;");
      } else if (currBookmarkList.isNotEmpty) {
        isInBookmark = true;
        print(
            "currBookmarkList.isNotEmpty in markedfun ;  isInBookmark is true : $isInBookmark;");
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        loader = false;
      });
    });
    // markedfun();
  }

  void onPressedFun(
      BookmarksProvider bookmarksPrvdr, BuildContext context) async {
    //isInBookmark = false;

    // bookmarksPrvdr = Provider.of<BookmarksProvider>(
    //   context,
    // );
    try {
      setState(() {
        loader = true;
      });
      //bookmarkList = [];
      await bookmarksPrvdr.fetchBookmarks();
      bookmarkList = bookmarksPrvdr.getBookmarkList;
      if (bookmarkList.isNotEmpty) {
        markedfun();
      } else if (bookmarkList.isEmpty) {
        isInBookmark = false;
      }

      if (isInBookmark == true) {
        await bookmarksPrvdr.deleteBookmark(
            whereArgs: widget.newsModel.bookmarkKey);
        // setState(() {});
        print("========= deleteBookmark");
      } else if (isInBookmark == false) {
        await bookmarksPrvdr.addToBookmark(
          newsModel: widget.newsModel,
        );
        print("========= addToBookmark =====");
      }
      await bookmarksPrvdr.fetchBookmarks().then((value) {
        //bookmarkList = [];
        bookmarkList = bookmarksPrvdr.getBookmarkList;

        if (bookmarkList.isNotEmpty) {
          markedfun();
        } else {
          isInBookmark = false;
        }
        //setState(() {});
        print("========= fetchBookmarks");
      });
    } catch (e) {
      GlobalMethods.errorDialog(errorMessage: e.toString(), context: context);
      rethrow;
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).getColor;
    Size size = Utils(context).getScreenSize;
    // final newsProvider = Provider.of<NewsProvider>(context);
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);
    //bookmarksProvider.fetchBookmarks();
    // final currentNews =
    //     newsProvider.findByDate(publishedAt: widget.publishedAt);

    ////
    print("========= build === isInBookmark:$isInBookmark");
    // bookmarkList = [];
    // bookmarkList = bookmarksProvider.getBookmarkList;
    // if (bookmarkList.isNotEmpty) {
    //   markedfun();
    // }
    setState(() {});
    print("========= build af === isInBookmark:$isInBookmark");

    ///
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "By ${widget.newsModel.authorName}",
          textAlign: TextAlign.center,
          style: TextStyle(color: color),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     IconlyLight.arrowLeft,
        //     color: color,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: loader == true
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  LoadingCircularProgressWidget(),
                ],
              ),
            )
          : ListView(
              //  physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.newsModel.title,
                        textAlign: TextAlign.justify,
                        style: titleTextStyle,
                      ),
                      const VerticalSpacing(25),
                      Row(
                        children: [
                          Text(
                            widget.newsModel.dateToShow,
                            style: smallTextStyle,
                          ),
                          const Spacer(),
                          Text(
                            widget.newsModel.readingTimeText,
                            style: smallTextStyle,
                          ),
                        ],
                      ),
                      const VerticalSpacing(20),
                    ],
                  ),
                ),
                bookmarksProvider.isLoading
                    ? Center(
                        child: Column(
                          children: [
                            Container(
                              height: size.height * 0.2,
                            ),
                            const Text("is loading .."),
                            const SizedBox(
                              height: 20,
                            ),
                            const LoadingCircularProgressWidget(),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: Hero(
                                  tag: widget.tag,
                                  child: FancyShimmerImage(
                                    boxFit: BoxFit.fill,
                                    errorWidget: Image.asset(
                                        'assets/images/empty_image.png'),
                                    imageUrl: widget.newsModel.urlToImage,
                                  ),
                                )),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        await Share.share(widget.newsModel.url,
                                            subject: 'Look what I made!');
                                      } catch (err) {
                                        GlobalMethods.errorDialog(
                                            errorMessage: err.toString(),
                                            context: context);
                                      }
                                    },
                                    child: Card(
                                      elevation: 10,
                                      shape: const CircleBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          IconlyLight.send,
                                          size: 28,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      onPressedFun(bookmarksProvider, context);
                                      // if (isInBookmark) {
                                      //   await bookmarksProvider
                                      //       .deleteBookmark(
                                      //           whereArgs: widget.newsModel.newsId)
                                      //       .then((value) {
                                      //     setState(() {});
                                      //   });
                                      //   // setState(() {});
                                      //   print("========= deleteBookmark");
                                      // } else {
                                      //   await bookmarksProvider
                                      //       .addToBookmark(
                                      //     newsModel: widget.newsModel,
                                      //   )
                                      //       .then((value) async {
                                      //     // setState(() {});

                                      //     await bookmarksProvider
                                      //         .fetchBookmarks()
                                      //         .then((value) {
                                      //       bookmarkList = [];
                                      //       bookmarkList =
                                      //           bookmarksProvider.getBookmarkList;
                                      //       setState(() {});
                                      //       // if (bookmarkList.isNotEmpty) {
                                      //       //   markedfun();
                                      //       // }
                                      //     });
                                      //   });
                                      //   //setState(() {});
                                      //   print("========= addToBookmark");
                                      // }
                                    },
                                    child: Card(
                                      elevation: 10,
                                      shape: const CircleBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          isInBookmark
                                              ? IconlyBold.bookmark
                                              : IconlyLight.bookmark,
                                          size: 28,
                                          color: isInBookmark
                                              ? Colors.green
                                              : color,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                const VerticalSpacing(20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextContent(
                        label: 'Description',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const VerticalSpacing(10),
                      TextContent(
                        label: widget.newsModel.description,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      const VerticalSpacing(
                        20,
                      ),
                      const TextContent(
                        label: 'Contents',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const VerticalSpacing(
                        10,
                      ),
                      TextContent(
                        label: widget.newsModel.content,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: kBottomNavigationBarHeight,
                )
              ],
            ),
    );
  }
}

class TextContent extends StatelessWidget {
  const TextContent({
    Key? key,
    required this.label,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      textAlign: TextAlign.justify,
      style: GoogleFonts.roboto(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}

//_____________

/*

class NewsDetailsScreen extends StatefulWidget {
  //  const NewsDetailsScreen({Key? key}) : super(key: key);

  ////
  //static const routeName = "/NewsDetailsScreen";
  const NewsDetailsScreen(
      {Key? key, required this.publishedAt, required this.index})
      : super(key: key);
  final String publishedAt;
  final int index;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool isInBookmark = false;
  // String? publishedAt;
  // var data;
  // // int? index;
  List<BookmarksModel> currBookmarkList = [];
  @override
  void didChangeDependencies() {
    // publishedAt = ModalRoute.of(context)!.settings.arguments as String;

    // index = ModalRoute.of(context)!.settings.arguments as int;
    final List<BookmarksModel> bookmarkList =
        Provider.of<BookmarksProvider>(context).getBookmarkList;
    if (bookmarkList.isEmpty) {
      return;
    }
    currBookmarkList = bookmarkList
        .where((element) => element.publishedAt == widget.publishedAt)
        .toList();
    if (currBookmarkList.isEmpty) {
      isInBookmark = false;
    } else {
      isInBookmark = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);

    final currentNews =
        newsProvider.findByDate(publishedAt: widget.publishedAt);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "By ${currentNews.authorName}",
          textAlign: TextAlign.center,
          style: TextStyle(color: color),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     IconlyLight.arrowLeft,
        //     color: color,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: ListView(
        //  physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentNews.title,
                  textAlign: TextAlign.justify,
                  style: titleTextStyle,
                ),
                const VerticalSpacing(25),
                Row(
                  children: [
                    Text(
                      currentNews.dateToShow,
                      style: smallTextStyle,
                    ),
                    const Spacer(),
                    Text(
                      currentNews.readingTimeText,
                      style: smallTextStyle,
                    ),
                  ],
                ),
                const VerticalSpacing(20),
              ],
            ),
          ),
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Hero(
                    tag: currentNews.publishedAt, //widget.index,
                    child: FancyShimmerImage(
                      boxFit: BoxFit.fill,
                      errorWidget: Image.asset('assets/images/empty_image.png'),
                      imageUrl: currentNews.urlToImage,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          try {
                            await Share.share(currentNews.url,
                                subject: 'Look what I made!');
                          } catch (err) {
                            GlobalMethods.errorDialog(
                                errorMessage: err.toString(), context: context);
                          }
                        },
                        child: Card(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              IconlyLight.send,
                              size: 28,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (isInBookmark) {
                            await bookmarksProvider.deleteBookmark(
                                whereArgs: currBookmarkList[0].newsId);
                            print("========= deleteBookmark");
                          } else {
                            await bookmarksProvider.addToBookmark(
                              newsModel: currentNews,
                            );
                            print("========= addToBookmark");
                          }
                          // await bookmarksProvider.fetchBookmarks();
                        },
                        child: Card(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              isInBookmark
                                  ? IconlyBold.bookmark
                                  : IconlyLight.bookmark,
                              size: 28,
                              color: isInBookmark ? Colors.green : color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const VerticalSpacing(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextContent(
                  label: 'Description',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const VerticalSpacing(10),
                TextContent(
                  label: currentNews.description,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                const VerticalSpacing(
                  20,
                ),
                const TextContent(
                  label: 'Contents',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const VerticalSpacing(
                  10,
                ),
                TextContent(
                  label: currentNews.content,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          Container(
            height: kBottomNavigationBarHeight,
          )
        ],
      ),
    );
  }
}

class TextContent extends StatelessWidget {
  const TextContent({
    Key? key,
    required this.label,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      textAlign: TextAlign.justify,
      style: GoogleFonts.roboto(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}


*/
