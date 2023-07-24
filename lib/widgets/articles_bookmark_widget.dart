import 'package:flutter/material.dart';
import 'package:my_news_app/consts/styles.dart';
import 'package:my_news_app/inner_screens/bookmark_details_screen.dart';
import 'package:my_news_app/inner_screens/news_details_webview.dart';
import 'package:my_news_app/models/bookmarks_model.dart';
import 'package:my_news_app/services/utils.dart';
import 'package:my_news_app/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ArticlesBookmarkWidget extends StatelessWidget {
  const ArticlesBookmarkWidget(
      {Key? key, required this.index, required this.globalKey})
      : super(key: key);
  // final String imageUrl, title, url, dateToShow, readingTime;
  final GlobalKey globalKey;
  final int index;
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    BookmarksModel bookmarkModel = Provider.of<BookmarksModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 3.0,
        shadowColor: Theme.of(context).colorScheme.secondary,
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: BookmarkDetailsScreen(
                    bookmarksModel: bookmarkModel,
                    globalKey: globalKey,
                  ),
                  inheritTheme: true,
                  ctx: context),
            );
          },
          child: Stack(
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  height: 20, //60,
                  width: 3,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  height: 3, //3,
                  width: 20, //60,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 20, // 60,
                  width: 3, // 3,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 3,
                  width: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                child: Container(
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: bookmarkModel.bookmarkKey,
                          child: bookmarkModel.urlToImage == null
                              ? Image.asset(
                                  'assets/images/empty_image.png',
                                  height: size.height * 0.12,
                                  width: size.height * 0.12,
                                  fit: BoxFit.fill,
                                )
                              : Image.memory(
                                  bookmarkModel.urlToImage!,
                                  height: size.height * 0.12,
                                  width: size.height * 0.12,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                          'assets/images/empty_image.png'),
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              bookmarkModel.title,
                              textAlign: TextAlign.justify,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: smallTextStyle,
                            ),
                            const VerticalSpacing(5),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                '🕒 ${bookmarkModel.readingTimeText}',
                                style: smallTextStyle,
                              ),
                            ),
                            FittedBox(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: NewsDetailsWebView(
                                                url: bookmarkModel.url),
                                            inheritTheme: true,
                                            ctx: context),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.link,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    bookmarkModel.dateToShow,
                                    maxLines: 1,
                                    style: smallTextStyle,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
