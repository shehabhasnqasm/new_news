import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_news_app/consts/styles.dart';
import 'package:my_news_app/models/bookmarks_model.dart';
import 'package:my_news_app/providers/bookmarks_sqflite_provider.dart';
import 'package:my_news_app/services/global_methods.dart';
import 'package:my_news_app/services/utils.dart';
import 'package:my_news_app/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class BookmarkDetailsScreen extends StatefulWidget {
  const BookmarkDetailsScreen(
      {Key? key, required this.bookmarksModel, required this.globalKey})
      : super(key: key);

  final BookmarksModel bookmarksModel;
  final GlobalKey globalKey;

  @override
  State<BookmarkDetailsScreen> createState() => _BookmarkDetailsScreenState();
}

class _BookmarkDetailsScreenState extends State<BookmarkDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).getColor;
    // final newsProvider = Provider.of<NewsProvider>(context);
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // widget.globalKey.currentState?.setState(() {});
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "By ${widget.bookmarksModel.authorName}",
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
        body: ListView(
          //  physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.bookmarksModel.title,
                    textAlign: TextAlign.justify,
                    style: titleTextStyle,
                  ),
                  const VerticalSpacing(25),
                  Row(
                    children: [
                      Text(
                        widget.bookmarksModel.dateToShow,
                        style: smallTextStyle,
                      ),
                      const Spacer(),
                      Text(
                        widget.bookmarksModel.readingTimeText,
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
                      tag: widget.bookmarksModel.bookmarkKey, //widget.index,
                      child: widget.bookmarksModel.urlToImage == null
                          ? Image.asset(
                              'assets/images/empty_image.png',
                              height: size.height * 0.3,
                              width: size.height * 0.3,
                              fit: BoxFit.fill,
                            )
                          : Image.memory(
                              widget.bookmarksModel.urlToImage!,
                              height: size.height * 0.3,
                              width: size.height * 0.3,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/empty_image.png'),
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
                              await Share.share(widget.bookmarksModel.url,
                                  subject: 'Look what !');
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
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("delete bookmark"),
                                    content: Row(
                                      children: const [
                                        Icon(
                                          IconlyBold.delete,
                                          //color: Colors.pink,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('Delete from bookmarks ?'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await bookmarksProvider
                                              .deleteBookmark(
                                                  whereArgs: widget
                                                      .bookmarksModel
                                                      .bookmarkKey)
                                              .then((value) {
                                            Navigator.canPop(context)
                                                ? Navigator.pop(context)
                                                : null;
                                          });
                                        },
                                        child: const Text('Ok'),
                                      ),
                                      //BackButton()
                                      TextButton(
                                        onPressed: () async {
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                }).then((value) async {
                              await bookmarksProvider.fetchBookmarks();
                              Navigator.pop(context);
                            });

                            ///
                          },
                          child: const Card(
                            elevation: 10,
                            shape: CircleBorder(),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                //  isInBookmark
                                IconlyBold.bookmark,
                                // : IconlyLight.bookmark,
                                size: 28,
                                color: Colors.green,
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
                    label: widget.bookmarksModel.description,
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
                    label: widget.bookmarksModel.content,
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
      ),
    );
  }

  // static Future<void> customDialog(
  //     {required String message,
  //     required BuildContext context,
  //     required BookmarksProvider bookmarksProvider,
  //     required String bookMarkKey}) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(message),
  //           content: Row(
  //             children: const [
  //               Icon(
  //                 IconlyBold.delete,
  //                 //color: Colors.pink,
  //               ),
  //               SizedBox(
  //                 width: 8,
  //               ),
  //               Text('Delete from bookmarks ?'),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () async {
  //                 // await bookmarksProvider.deleteBookmark(
  //                 //     whereArgs: bookMarkKey);
  //                 //     .then((value) {
  //                 //   Navigator.canPop(context) ? Navigator.pop(context) : null;
  //                 // });
  //                 // Navigator.pop(context);
  //                 if (Navigator.canPop(context)) {
  //                   Navigator.pop(context);
  //                 }
  //               },
  //               child: const Text('Ok'),
  //             ),
  //             TextButton(
  //               onPressed: () async {
  //                 if (Navigator.canPop(context)) {
  //                   Navigator.pop(context);
  //                 }
  //               },
  //               child: const Text('Cancel'),
  //             ),
  //           ],
  //         );
  //       });
  // }
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
