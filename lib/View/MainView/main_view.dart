import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:news_portal/View/History/history_view.dart';
import 'package:news_portal/View/Trending/trending_view.dart';

import '../Bookmark/bookmark_view.dart';
import '../Categories/Startup.dart';
import 'home_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  List<Widget> pageList = <Widget>[
    HomeView(),
    const BookMarkView(),
    const HistoryView(),
    Container(),
    //setting(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: pageList[_pageIndex],
        bottomNavigationBar: CurvedNavigationBar(
          height: 60.0,
          items: const [
            Icon(Icons.trending_up_sharp),
            Icon(Icons.bookmark_added),
            Icon(Icons.category_outlined),
            Icon(Icons.notification_add_outlined),
          ],
          color: Colors.teal,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.teal,
          animationCurve: Curves.easeInOut,
          onTap: (values) {
            setState(() {
              _pageIndex = values;
            });
          },
        ),
      ),
    );
  }
}
