import 'package:flutter/material.dart';
import 'package:my_news_app/consts/theme_data.dart';
import 'package:my_news_app/providers/bookmarks_sqflite_provider.dart';
import 'package:my_news_app/providers/news_provider.dart';
import 'package:my_news_app/providers/theme_provider.dart';
import 'package:my_news_app/screens/home_screen2.dart';
import 'package:my_news_app/services/sqflite/crud_sqflite.dart';
import 'package:my_news_app/services/sqflite/db_sqflite.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Need it to access the theme Provider
  ThemeProvider themeChangeProvider = ThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  //Fetch the current theme
  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          //Notify about theme changes
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarksProvider(
              bookMarkCrud: BookMarkCrud(sqfliteDB: SqfliteDB())),
        ),
      ],
      child:
          //Notify about theme changes
          Consumer<ThemeProvider>(builder: (context, themeChangeProvider, ch) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'News App ',
          theme: Styles.themeData(themeChangeProvider.getDarkTheme, context),
          home: const HomeScreen2(),
          // routes: {
          //   NewsDetailsScreen.routeName: (ctx) =>  NewsDetailsScreen(),
          // },
        );
      }),
    );
  }
}
