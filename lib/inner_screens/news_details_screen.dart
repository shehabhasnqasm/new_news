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

class NewsDetailsScreen extends StatefulWidget {
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

  List<BookmarksModel> currBookmarkList = [];
  List<BookmarksModel> bookmarkList = [];
  bool loader = false;

  @override
  void initState() {
    super.initState();
    isInBookmark = true;
    currBookmarkList = [];
    bookmarkList = [];
    fetchItemNewsDetail();
  }

  void markedNewsfun() async {
    currBookmarkList = [];
    currBookmarkList = bookmarkList
        .where((element) => element.bookmarkKey == widget.newsModel.bookmarkKey)
        .toList();

    if (currBookmarkList.isEmpty) {
      isInBookmark = false;
    } else if (currBookmarkList.isNotEmpty) {
      isInBookmark = true;
    }
  }

//____________ fetch one item news detail  function_________________________
  Future<void> fetchItemNewsDetail() async {
    loader = true;
    final bookmarksProvider =
        Provider.of<BookmarksProvider>(context, listen: false);
    bookmarkList = await bookmarksProvider.fetchBookmarks();
    if (bookmarkList.isEmpty) {
      isInBookmark = false;
    } else if (bookmarkList.isNotEmpty) {
      currBookmarkList = [];
      currBookmarkList = bookmarkList
          .where(
              (element) => element.publishedAt == widget.newsModel.publishedAt)
          .toList();
      if (currBookmarkList.isEmpty) {
        isInBookmark = false;
      } else if (currBookmarkList.isNotEmpty) {
        isInBookmark = true;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        loader = false;
      });
    });
    // markedfun();
  }
  //__________________   save the news in to bookmark or remove from bookmark , ________________

  void saveOrUnsavethenews(
      BookmarksProvider bookmarksPrvdr, BuildContext context) async {
    try {
      setState(() {
        loader = true;
      });
      //bookmarkList = [];
      await bookmarksPrvdr.fetchBookmarks();
      bookmarkList = bookmarksPrvdr.getBookmarkList;
      if (bookmarkList.isNotEmpty) {
        markedNewsfun();
      } else if (bookmarkList.isEmpty) {
        isInBookmark = false;
      }
      if (isInBookmark == true) {
        await bookmarksPrvdr.deleteBookmark(
            whereArgs: widget.newsModel.bookmarkKey);
        // setState(() {});
      } else if (isInBookmark == false) {
        await bookmarksPrvdr.addToBookmark(
          newsModel: widget.newsModel,
        );
      }
      await bookmarksPrvdr.fetchBookmarks().then((value) {
        //bookmarkList = [];
        bookmarkList = bookmarksPrvdr.getBookmarkList;
        if (bookmarkList.isNotEmpty) {
          markedNewsfun();
        } else {
          isInBookmark = false;
        }
        //setState(() {});
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

  //___________________________________________________________

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).getColor;
    Size size = Utils(context).getScreenSize;

    final bookmarksProvider = Provider.of<BookmarksProvider>(context);

    setState(() {});
    print("========= build af === isInBookmark:$isInBookmark");

    ///
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "By${widget.newsModel.authorName}",
          textAlign: TextAlign.center,
          style: TextStyle(color: color),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                boxShadow: const [
                  // BoxShadow(color: Colors.white),
                  BoxShadow(color: Colors.white, blurRadius: 0.1)
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              IconlyBold.arrowLeft,
              color: Theme.of(context).colorScheme.secondary,
              size: 40,
            ),
          ),
        ),
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
                                      // onPressedFun(bookmarksProvider, context);
                                      saveOrUnsavethenews(
                                          bookmarksProvider, context);
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
