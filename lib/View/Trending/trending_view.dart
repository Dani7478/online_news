import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Bookmark/bookmark_view.dart';
import 'package:news_portal/View/Common%20Widgets/snackbar.dart';
import 'package:webfeed/webfeed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../Model/sqlitedbprovider.dart';
import '../NewsDetail/news_detail_view.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({Key? key}) : super(key: key);

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

bool isAdVisible = true;
bool isLoading = true;
late RssFeed rss = RssFeed();
String searchtext = '';

class _TrendingViewState extends State<TrendingView> {
  bool internet = true;
  bool loading = false;
  List<bool> favlist = [];
  List<bool> bookmrklist = [];
  late var offlineData;
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
  }

  loadData() async {
    print('loading');
    if (internet == true) {
      clearTrendingNews();
      try {
        const API = 'https://www.geo.tv/rss/1/1';
        final response = await get(Uri.parse(API));
        var channel = RssFeed.parse(response.body);
        setState(() {
          rss = channel;
          isLoading = false;
        });

        for (int i = 0; i < rss.items!.length; i++) {
          final item = rss.items![i];
          String title = item.title.toString();
          String description = item.description.toString();
          String link = item.link.toString();
          String pubDate = item.pubDate.toString();
          String date =
              DateFormat('MMM dd yyyy').format(DateTime.parse(pubDate));
          saveTrendingNews(title, description, link, date);
          DateTime fortime = DateTime.parse(pubDate);
          String time = '${fortime.hour}:${fortime.minute}';

          favlist.add(false);
        }
      } catch (err) {
        throw err;
      }
      isLoading = false;
      setState(() {});
    }
    if (internet == false) {
      offlineData = await dbHelper.getAllTrending();
      setState(() {});

      for (int i = 0; i < offlineData.length; i++) {
        favlist.add(false);
      }
      print('offline news = ${offlineData.length}');
    }
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      loadData();
      print('Mobile Data is Connected');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      loadData();
      print('Wifi Data is Connected');
    } else {
      internet = false;
      loadData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: titleText,
      //   actions: [
      //     PopupMenuButton<String>(onSelected: (value) {
      //       if (value == "bookmark") {
      //         Get.to(BookMarkView());
      //       }
      //     }, itemBuilder: (BuildContext context) {
      //       return [
      //         PopupMenuItem(
      //           // ignore: sort_child_properties_last
      //           child: Row(
      //             children: [
      //               IconButton(
      //                 icon: const Icon(
      //                   Icons.bookmark,
      //                   color: Color(0xFF0f65b3),
      //                 ),
      //                 onPressed: () async {
      //                   Get.to(BookMarkView());
      //                 },
      //               ),
      //               const SizedBox(
      //                 width: 10.0,
      //               ),
      //               const Text(
      //                 "Bookmark",
      //                 style: TextStyle(fontWeight: FontWeight.w500),
      //               )
      //             ],
      //           ),
      //           value: "bookmark",
      //         ),
      //       ];
      //     }),
      //   ],
      //     //  bottom: const TabBar(
      //     //   tabs: [
      //     //     Tab(
      //     //        text: ("One"),
      //     //     ),
      //     //     Tab(
      //     //       text: ("Two"),
      //     //     ),
      //     //     Tab(text: ("Three"),)
      //     //   ],
      //     // ),
      // ),
      body: Column(
        children: [
          Container(
              width: size.width,
              height: size.height * 0.05,
              color: internet == true
                  ? Color.fromARGB(255, 25, 216, 31)
                  : Color.fromARGB(255, 255, 54, 40),
              child: internet == true
                  ? Center(
                      child: Text(
                      'ONLINE',
                      style: internetStyle,
                    ))
                  : Center(
                      child: Text(
                      'OFFLINE',
                      style: internetStyle,
                    ))),
          Container(
            width: size.width,
            height: size.height * 0.08,
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                onChanged: (value) {
                  searchtext = value;
                  setState(() {});
                  print(searchtext);
                },
                // controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                //obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Search News .....',
                  // border: OutlineInputBorder(),

                  // prefixIcon: Icon(Icons.lock),
                  //  suffixIcon: Icon(Icons.remove_red_eye),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: size.width,
              height: size.height * 0.5,
              color: Colors.transparent,
              child: NewsPortion(size),
            ),
          )
        ],
      ),
    );
  }

  NewsPortion(Size size) {
    return isLoading == true
        ? Loader()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: ListView.builder(
                itemCount:
                    internet == true ? rss.items!.length : offlineData.length,
                itemBuilder: (context, index) {
                  // 0 1 2 3 ...19
                  late String title;
                  late String description;
                  late String link;
                  late String date;
                  late String time;
                  if (internet == true) {
                    final item = rss.items![index];
                    title = item.title.toString();
                    description = item.description.toString();
                    link = item.link.toString();
                    String pubDate = item.pubDate.toString();
                    date = DateFormat('MMM dd yyyy')
                        .format(DateTime.parse(pubDate));
                        DateTime datetime=DateTime.parse(pubDate);
                        time='${datetime.hour}:${datetime.minute}';

                  }
                  if (internet == false) {
                    title = offlineData[index]['title'];
                    description = offlineData[index]['description'];
                    link = offlineData[index]['link'];
                    date = offlineData[index]['date'];
                  }

                  // print(favlist.length);
                  // saveTrendingNews(title, description, link, date);
                  // favlist.add(false);
                  return title.toLowerCase().contains(searchtext) //maryam
                      ? InkWell(
                          onTap: () {
                            Get.to(NewsDetailView(
                              description: description,
                              link: link,
                              title: title,
                            ));
                          },
                          child: Container(
                            height: 200,
                            child: Card(
                              color: Colors.grey,
                              elevation: 20,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Center(
                                        child: Text(
                                      '# ${index + 1}',
                                      style: numberStyle,
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 30),
                                    child: Container(
                                      width: size.width * 0.55,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: headingStyle,
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (favlist[index] == false) {
                                                    favlist[index] = true;
                                                    setState(() {});
                                                  } else {
                                                    favlist[index] = false;
                                                    setState(() {});
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      'images/heart.png',
                                                      height: 20,
                                                      color: favlist[index] ==
                                                              true
                                                          ? Color.fromARGB(
                                                              255, 248, 55, 71)
                                                          : Colors.black,
                                                    ),
                                                    Text('Like',
                                                        style: GoogleFonts.josefinSans(
                                                            color: favlist[
                                                                        index] ==
                                                                    true
                                                                ? const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    248,
                                                                    55,
                                                                    71)
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Map<String, dynamic> row = {
                                                    'title': title,
                                                    'description': description,
                                                    'link': link,
                                                    'date': date,
                                                  };

                                                  final id = await dbHelper
                                                      .insertBookmark(row);
                                                  print('inserted row id: $id');
                                                  if (id != null) {
                                                    snackBar(
                                                        context,
                                                        'News Saved in Bookmark',
                                                        'OK');
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        'images/comment.png',
                                                        height: 20),
                                                    Text('Bookmark',
                                                        style: GoogleFonts
                                                            .josefinSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15))
                                                  ],
                                                ),
                                              ),

                                              //  SizedBox(width: 20,),

                                              //  Text(date),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                              Text(
                                                date,
                                                style: subHeadingStyle,
                                              ),
                                              SizedBox(width: 8,),
                                              Text(
                                                time,
                                                style: subHeadingStyle,
                                              )
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        )
                      : Container();
                }),
          );
  }

  Loader() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.teal,
        size: 80,
      ),
    );
  }

  saveTrendingNews(
      String title, String description, String link, String date) async {
    Map<String, dynamic> row = {
      'title': title,
      'description': description,
      'link': link,
      'date': date,
    };

    int id = await dbHelper.insertTrending(row);
    //  print('Trending added with id ${id}');
  }

  clearTrendingNews() async {
    var response = await dbHelper.clearTrending();
    print('Response : ${response}');
  }
}

Text titleText = Text(
  "Trending News",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);

TextStyle internetStyle = GoogleFonts.josefinSans(
    fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700);

TextStyle numberStyle = GoogleFonts.josefinSans(
    fontSize: 20,
    color: Color.fromARGB(255, 247, 28, 13),
    fontWeight: FontWeight.w900);
