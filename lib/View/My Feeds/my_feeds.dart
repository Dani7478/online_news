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

class MyFeedsView extends StatefulWidget {
  const MyFeedsView({Key? key}) : super(key: key);

  @override
  State<MyFeedsView> createState() => _MyFeedsViewState();
}

bool isAdVisible = true;
bool isLoading = true;
late RssFeed rss = RssFeed();
String searchtext = '';
List<String> channelList = [];
List<String> channelLinkList = [];

class _MyFeedsViewState extends State<MyFeedsView> {
  bool internet = true;
  bool loading = false;
  List<bool> favlist = [];
  List<bool> bookmrklist = [];
  List offlineData = [];
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callfunctions();
  }

  @override
  void dispose() {
    // TODO: implement initState
    channelLinkList.clear();
    channelList.clear();
    super.dispose();
  }
  callfunctions() async {
    await checkInternet();
    await loadChannels();
    await loadData();
  }

  checkInternet() async {
    print('checking internet.....\n');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      internet = true;
      print('connection : Mobile \n');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      internet = true;
      print('connection : Wifi \n');
    } else {
      print('connection : no internet \n');
      internet = false;
    }
    print('_____________________________________________________\n');
  }

  loadChannels() async {
    // ignore: avoid_print
    print('loading channels ......\n');
    List list = await dbHelper.getAllIntrestRows();
    for (int i = 0; i < list.length; i++) {
      channelList.add(list[i]['title']);
      channelLinkList.add(list[i]['link']);
    }
    print('total channels : ${channelLinkList.length}\n');
    print('_____________________________________________________\n');
  }

  loadData() async {
    print('loading News.......\n');
    if (internet == true) {
      clearFeedNews();
      for (int i = 0; i < channelLinkList.length; i++) {
        print('Fetching Online News....');
        try {
          String API = channelLinkList[i];
          final response = await get(Uri.parse(API));
          var channel = RssFeed.parse(response.body);
          rss = channel;

          for (int i = 0; i < rss.items!.length; i++) {
            print('Saving news ${i}....');
            final item = rss.items![i];
            String title = item.title.toString();
            String description = item.description.toString();
            String link = item.link.toString();
            String pubDate = item.pubDate.toString();
            DateTime dateTime = DateTime.parse(pubDate);
            String date = DateFormat('MMM dd yyyy').format(dateTime);
            String time = '${dateTime.hour}:${dateTime.minute}';
            saveFeedNews(title, description, link, date, time);

            favlist.add(false);
          }
        } catch (err) {
          throw err;
        }
      }
    }
    if (internet == false || internet == true) {
      print('Fecthing Offline News');
      offlineData = await dbHelper.allFeeds();
      setState(() {});
      for (int i = 0; i < offlineData.length; i++) {
        favlist.add(false);
      }
      print('offline news = ${offlineData.length}');
    }
    isLoading = false;
    setState(() {});
    print('_____________________________________________________\n');
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
    return isLoading == true || offlineData.length == 0
        ? Loader()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: ListView.builder(
                itemCount: offlineData.length,
                itemBuilder: (context, index) {
                  String title = offlineData[index]['title'];
                  String description = offlineData[index]['description'];
                  String link = offlineData[index]['link'];
                  String date = offlineData[index]['date'];
                  String time = offlineData[index]['time'];
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
                                                    'time': time
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    date,
                                                    style: subHeadingStyle,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
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

  saveFeedNews(String title, String description, String link, String date,
      String time) async {
    print('News Saving...');
    Map<String, dynamic> row = {
      'title': title,
      'description': description,
      'link': link,
      'date': date,
      'time': time
    };

    int id = await dbHelper.insertFeed(row);
    //  print('Trending added with id ${id}');
  }

  clearFeedNews() async {
    var response = await dbHelper.clearFeed();
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
