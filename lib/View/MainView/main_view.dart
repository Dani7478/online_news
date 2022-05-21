import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:news_portal/View/Trending/trending_view.dart';

import '../Categories/Startup.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  List<Widget> pageList = <Widget>[
     TrendingView(),
     StartupScreen()
    //setting(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 60.0,
        items:const [
          Icon(Icons.trending_up_sharp),
          Icon(Icons.category_outlined),
          Icon(Icons.bookmark_added),
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
    );
  }
}