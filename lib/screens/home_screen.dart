import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_news_app/consts/vars.dart';
import 'package:my_news_app/inner_screens/search_screen.dart';
import 'package:my_news_app/models/news_model.dart';
import 'package:my_news_app/providers/news_provider.dart';
import 'package:my_news_app/providers/theme_provider.dart';
import 'package:my_news_app/services/utils.dart';
import 'package:my_news_app/widgets/articles_widget.dart';
import 'package:my_news_app/widgets/drawer_widget.dart';
import 'package:my_news_app/widgets/top_tending.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newsType = NewsType.allNews;
  int currentPageIndex = 0;
  String sortBy = SortByEnum.publishedAt.name;
  String category = "general";

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    // \

    return SafeArea(
      child: Scaffold(
          //resizeToAvoidBottomInset: true,
          appBar: AppBar(
            iconTheme: IconThemeData(color: color),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            title: Text(
              'News app',
              style: GoogleFonts.lobster(
                  textStyle: TextStyle(
                      color: color, fontSize: 20, letterSpacing: 0.6)),
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
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                //const VerticalSpacing(10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Trending",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                SizedBox(
                  height: size.height * 0.37,
                  width: size.width,
                  child: FutureBuilder<List<NewsModel>>(
                      future: newsProvider.fetchTopHeadlines(category),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: size.height * 0.3,
                            child: Center(
                              child: SpinKitFadingCube(
                                color: Theme.of(context).colorScheme.secondary,
                                size: 50.0,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            alignment: Alignment.center,
                            height: size.height * 0.2,
                            child: Center(
                                child: Text(
                              "an error occured ${snapshot.error} ;; or check your internet !",
                              style: const TextStyle(fontSize: 20),
                            )),
                          );
                        } else if (snapshot.data == null) {
                          // return const Expanded(
                          //   child: EmptyNewsWidget(
                          //     text: "No news found",
                          //     imagePath: 'assets/images/no_news.png',
                          //   ),
                          // );
                          return Container(
                            alignment: Alignment.center,
                            height: size.height * 0.2,
                            child: const Center(
                                child: Text(
                              "No news found !",
                              style: TextStyle(fontSize: 20),
                            )),
                          );
                        }
                        return SizedBox(
                          // height: size.height * 0.30,
                          child: Swiper(
                            autoplayDelay: 8000,
                            autoplay: true,
                            itemWidth: size.width * 0.9,
                            layout: SwiperLayout.STACK,
                            viewportFraction: 0.9,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: snapshot.data![index],
                                child: TopTrendingWidget(
                                  index: index,
                                ),
                              );
                            },
                          ),
                        );
                      })),
                ),
                const Divider(),
                // SizedBox(
                //   height: size.height * (20 / size.height),
                // ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "All news",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                Row(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_drop_down),
                            DropdownButton(
                                value: sortBy,
                                icon: null,
                                iconSize: 0.0,
                                alignment: Alignment.centerLeft,
                                items: dropDownItems,
                                onChanged: (String? value) {
                                  setState(() {
                                    sortBy = value!;
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryKeywords.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            setState(() {
                              category = categoryKeywords[index];
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20 / 2,
                            ),
                            decoration: BoxDecoration(
                              color: category == categoryKeywords[index]
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            child: category == categoryKeywords[index]
                                ? Text(
                                    categoryKeywords[index],
                                    style: TextStyle(
                                        color: theme.getDarkTheme
                                            ? Colors.white
                                            : Colors.white),
                                  )
                                : Text(
                                    categoryKeywords[index],
                                  ),
                          ),
                        );
                      }),
                ),

                Flexible(
                  child: FutureBuilder<List<NewsModel>>(
                      future: newsProvider.fetchAllNews(
                          pageIndex: currentPageIndex + 1,
                          sortBy: sortBy,
                          category: category),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // return const Expanded(
                          //   child: LoadingWidget(newsType: NewsType.allNews),
                          // );
                          //  return const LoadingWidget(newsType: NewsType.allNews);
                          return SizedBox(
                            height: size.height * 0.3,
                            child: Center(
                              child: SpinKitFadingCube(
                                color: Theme.of(context).colorScheme.secondary,
                                size: 50.0,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return SizedBox(
                            height: size.height * 0.3,
                            child: Center(
                              child: SpinKitFadingCube(
                                color: Theme.of(context).colorScheme.secondary,
                                size: 50.0,
                              ),
                            ),
                          );
                        } else if (snapshot.data == null) {
                          return Expanded(
                            child: SizedBox(
                              height: size.height * 0.3,
                              child: Center(
                                child: SpinKitFadingCube(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                            //physics: const BouncingScrollPhysics(),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (ctx, index) {
                              return ChangeNotifierProvider.value(
                                value: snapshot.data![index],
                                child: ArticlesWidget(index: index),
                              );
                            });
                      })),
                ),
                const SizedBox(
                  height: 20,
                )
                //  LoadingWidget(newsType: newsType),
              ]),
            ),
          ),
          bottomNavigationBar: bottomNavBar(size)),
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

      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(size.height * (20 / size.height)),
              topLeft: Radius.circular(size.height * (20 / size.height))),
          color: color.baseShimmerColor),

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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
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
