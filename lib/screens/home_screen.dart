// import 'dart:developer';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';


// import '../models/news_model.dart';
// import '../providers/news_provider.dart';
// import '../providers/theme_provider.dart';
// import '../services/news_api.dart';
// import '../widgets/articles_widget.dart';
// import '../widgets/loading_widget.dart';
// import '../widgets/tabs.dart';
// import '../widgets/top_tending.dart';
/*
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newsType = NewsType.allNews;
  int currentPageIndex = 0;
  String sortBy = SortByEnum.publishedAt.name;

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);

    // \

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            'News app',
            style: GoogleFonts.lobster(
                textStyle:
                    TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const SearchScreen(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              icon: const Icon(
                IconlyLight.search,
              ),
            )
          ],
        ),
        drawer: const DrawerWidget(),
        /////

        //
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TabsWidget(
                    text: 'All news',
                    color: newsType == NewsType.allNews
                        ? Theme.of(context).cardColor
                        : Colors.transparent,
                    function: () {
                      if (newsType == NewsType.allNews) {
                        return;
                      }
                      setState(() {
                        newsType = NewsType.allNews;
                      });
                    },
                    fontSize: newsType == NewsType.allNews ? 22 : 14,
                    borderColor: newsType == NewsType.allNews
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.transparent),
                // const SizedBox(
                //   width: 25,
                // ),
                // Spacer(),
                TabsWidget(
                    text: 'Top trending',
                    color: newsType == NewsType.topTrending
                        ? Theme.of(context).cardColor
                        : Colors.transparent,
                    function: () {
                      if (newsType == NewsType.topTrending) {
                        return;
                      }
                      setState(() {
                        newsType = NewsType.topTrending;
                      });
                    },
                    fontSize: newsType == NewsType.topTrending ? 22 : 14,
                    borderColor: newsType == NewsType.topTrending
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.transparent),
              ],
            ),
            const VerticalSpacing(10),

            const VerticalSpacing(10),
            newsType == NewsType.topTrending
                ? Container()
                : Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton(
                            value: sortBy,
                            items: dropDownItems,
                            onChanged: (String? value) {
                              setState(() {
                                sortBy = value!;
                              });
                            }),
                      ),
                    ),
                  ),
            FutureBuilder<List<NewsModel>>(
                future: newsType == NewsType.topTrending
                    ? newsProvider.fetchTopHeadlines()
                    : newsProvider.fetchAllNews(
                        pageIndex: currentPageIndex + 1, sortBy: sortBy),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return newsType == NewsType.allNews
                        ? LoadingWidget(newsType: newsType)
                        : Expanded(
                            child: LoadingWidget(newsType: newsType),
                          );
                  } else if (snapshot.hasError) {
                    return Expanded(
                      child: EmptyNewsWidget(
                        text:
                            "an error occured ${snapshot.error} ;; or check your internet",
                        imagePath: 'assets/images/no_news.png',
                      ),
                    );
                  } else if (snapshot.data == null) {
                    return const Expanded(
                      child: EmptyNewsWidget(
                        text: "No news found",
                        imagePath: 'assets/images/no_news.png',
                      ),
                    );
                  }
                  return newsType == NewsType.allNews
                      ? Expanded(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (ctx, index) {
                                return ChangeNotifierProvider.value(
                                  value: snapshot.data![index],
                                  child: ArticlesWidget(index: index
                                      // imageUrl: snapshot.data![index].,
                                      // dateToShow: snapshot.data![index].dateToShow,
                                      // readingTime:
                                      //     snapshot.data![index].readingTimeText,
                                      // title: snapshot.data![index].title,
                                      // url: snapshot.data![index].url,
                                      ),
                                );
                              }),
                        )
                      : SizedBox(
                          height: size.height * 0.6,
                          child: Swiper(
                            autoplayDelay: 8000,
                            autoplay: true,
                            itemWidth: size.width * 0.9,
                            layout: SwiperLayout.STACK,
                            viewportFraction: 0.9,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: snapshot.data![index],
                                child: TopTrendingWidget(
                                  // url: snapshot.data![index].url,
                                  index: index,
                                ),
                              );
                            },
                          ),
                        );
                })),

            //  LoadingWidget(newsType: newsType),
          ]),
        ),

        ///////
        bottomNavigationBar:
            newsType == NewsType.allNews ? bottomNavBar(size) : null,

        ///
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> menuItem = [
      DropdownMenuItem(
        value: SortByEnum.relevancy.name,
        child: Text(SortByEnum.relevancy.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.publishedAt.name,
        child: Text(SortByEnum.publishedAt.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.popularity.name,
        child: Text(SortByEnum.popularity.name),
      ),
    ];
    return menuItem;
  }

  Widget paginationButtons({required Function function, required String text}) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.all(6),
          textStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      child: Text(text),
    );
  }

  Widget bottomNavBar(Size size) {
    final color = Utils(context);
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.only(
      //   top: size.height * (20 / size.height),
      //   bottom: size.height * (20 / size.height),
      //   right: size.width * (20 / size.width),
      //   left: size.width * (20 / size.width),
      // ),
      decoration: BoxDecoration(
          // border: Border.all(
          //   color: Theme.of(context)
          //       .colorScheme
          //       .secondary, //                   <--- border color
          //   width: 1.0,
          // ),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(size.height * (20 / size.height)),
              topLeft: Radius.circular(size.height * (20 / size.height))),
          // color: Theme.of(context).navigationBarTheme.backgroundColor
          // color: Theme.of(context).navigationBarTheme.backgroundColor //baseShimmerColor
          color: color.baseShimmerColor //baseShimmerColor
          ),

      //
      height: size.height * (90 / size.height),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            paginationButtons(
              text: "Prev",
              function: () {
                if (currentPageIndex == 0) {
                  return;
                }
                setState(() {
                  currentPageIndex -= 1;
                });
              },
            ),
            Flexible(
              flex: 2,
              child: SizedBox(
                height: size.height * (70 / size.height),
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      // return Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Text("$index")
                      //     // paginationButtons(text: "$index", function: () {}),
                      //     );
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          //shape: CircleBorder(),

                          borderRadius: BorderRadius.circular(5),
                          color: currentPageIndex == index
                              ? Colors.blue //litePurpul //Colors.blue
                              : Theme.of(context).cardColor,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentPageIndex = index;
                              });
                            },
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text("${index + 1}"),
                            )),
                          ),
                        ),
                      );
                    })),
              ),
            ),
            paginationButtons(
              text: "Next",
              function: () {
                if (currentPageIndex == 4) {
                  return;
                }
                setState(() {
                  currentPageIndex += 1;
                });
                // print('$currentPageIndex index');
              },
            ),
          ],
        ),
      ),
    );
  }
}

*/