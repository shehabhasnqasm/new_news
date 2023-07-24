import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:my_news_app/inner_screens/news_details_webview.dart';
import 'package:my_news_app/models/news_model.dart';
import 'package:my_news_app/services/utils.dart';
import 'package:my_news_app/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../consts/styles.dart';
import '../inner_screens/news_details_screen.dart';

class ArticlesWidget extends StatelessWidget {
  const ArticlesWidget({Key? key, required this.index, this.isBookmark = false})
      : super(key: key);
  // final String imageUrl, title, url, dateToShow, readingTime;
  final bool isBookmark;
  final int index;
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final newsModelProvider = Provider.of<NewsModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        elevation: 2,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: NewsDetailsScreen(
                      newsModel: newsModelProvider,
                      tag: "${newsModelProvider.publishedAt}$index"),
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
                  height: 60,
                  width: 3,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  height: 3,
                  width: 60,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 60,
                  width: 3,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 3,
                  width: 60,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: "${newsModelProvider.publishedAt}$index", //index,
                        child: FancyShimmerImage(
                          height: size.height * 0.12,
                          width: size.height * 0.12,
                          boxFit: BoxFit.fill,
                          errorWidget:
                              Image.asset('assets/images/empty_image.png'),
                          imageUrl: newsModelProvider.urlToImage,
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
                            newsModelProvider.title,
                            textAlign: TextAlign.justify,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: smallTextStyle,
                          ),
                          const VerticalSpacing(5),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '🕒 ${newsModelProvider.readingTimeText}',
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
                                          type: PageTransitionType.rightToLeft,
                                          child: NewsDetailsWebView(
                                              url: newsModelProvider.url),
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
                                  newsModelProvider.dateToShow,
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
            ],
          ),
        ),
      ),
    );
  }
}
