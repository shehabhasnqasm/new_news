//

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_news_app/providers/bookmarks_sqflite_provider.dart';
import 'package:my_news_app/services/utils.dart';
import 'package:my_news_app/widgets/utils/utils_widget/loader.dart';
import 'package:my_news_app/widgets/articles_bookmark_widget.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final GlobalKey globalKey = GlobalKey<ScaffoldState>();
  bool loading = true;
  bool dbExist = false;
  @override
  void initState() {
    super.initState();
    fetchAllBookmarkFun();
  }

//----------------
  fetchAllBookmarkFun() async {
    final bookmarksProvider =
        Provider.of<BookmarksProvider>(context, listen: false);
    try {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          loading = true;
        });
      });

      await bookmarksProvider.isExist().then((value) async {
        if (value == true) {
          dbExist = true;

          await bookmarksProvider.fetchBookmarks();
        } else {
          dbExist = false;
          return;
        }
      });
    } catch (e) {
      return;
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          loading = false;
        });
      });
    }
  }

//-----------------------
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    var bookmarksPro = Provider.of<BookmarksProvider>(
      context,
    );

    print("BookmarkScreen");

    return dbExist == true
        ? Scaffold(
            key: globalKey,
            //drawer: const DrawerWidget(),
            appBar: AppBar(
              iconTheme: IconThemeData(color: color),
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              // automaticallyImplyLeading: true,
              //leadingWidth: 70,
              title: Text(
                'Bookmarks',
                style: GoogleFonts.lobster(
                    textStyle: TextStyle(
                        color: color, fontSize: 20, letterSpacing: 0.6)),
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
            body: loading
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        LoadingCircularProgressWidget(),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      bookmarksPro.getBookmarkList.isEmpty
                          ? Expanded(
                              child: Image.asset(
                                // "assets/images/empty_image.png",
                                "assets/images/empty_bookmark.png",
                                // height: 300,
                                // width: 300,
                              ),
                            )
                          : Container(),
                      bookmarksPro.getBookmarkList.isEmpty
                          ? Expanded(
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: const Center(
                                  child: Text(
                                    "No bookmarks yet now !",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Expanded(
                          child: ListView.builder(
                              itemCount: bookmarksPro.getBookmarkList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: ((context, index) {
                                return ChangeNotifierProvider.value(
                                    value: bookmarksPro.getBookmarkList[index],
                                    child: ArticlesBookmarkWidget(
                                        index: index, globalKey: globalKey));
                                //  child: articlesBookmarkWidget(context , ));
                              }))),
                    ],
                  ),
          )
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: color),
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              // automaticallyImplyLeading: true,
              //leadingWidth: 70,
              title: Text(
                'Bookmarks',
                style: GoogleFonts.lobster(
                    textStyle: TextStyle(
                        color: color, fontSize: 20, letterSpacing: 0.6)),
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // EmptyNewsWidget(
                //   imagePath: "assets/images/empty_bookmark.png",
                //   text: "NO bookmarks yet now !.",
                // ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "NO bookmarks yet now !.",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
  }
}
