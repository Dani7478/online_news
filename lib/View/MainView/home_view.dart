import 'package:flutter/material.dart';
import 'package:news_portal/View/Categories/Startup.dart';
import 'package:news_portal/View/My%20Feeds/my_feeds.dart';
import 'package:news_portal/View/Trending/trending_view.dart';  

void main() => runApp(HomeView());  
  
class HomeView extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return   DefaultTabController(  
        length: 2,  
        child: Scaffold(  
          appBar: AppBar(
            toolbarHeight: 0,
           // title: Text('Flutter Tabs Demo'),
            bottom:const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.trending_up_sharp), text: "Trending"),
            Tab(icon: Icon(Icons.my_library_books), text: "My Feed")
          ],
            ),
          ),
          body:const TabBarView(  
            children: [  
              TrendingView(),
              MyFeedsView(),
            ],  
          ),  
        ),  
      ); 
     
  }  
}  