import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Authentication/login_view.dart';
import 'package:news_portal/View/Common%20Widgets/snackbar.dart';
import 'package:webfeed/webfeed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../Model/sqlitedbprovider.dart';
import '../NewsDetail/news_detail_view.dart';

class BookMarkView extends StatefulWidget {
  const BookMarkView({Key? key}) : super(key: key);

  @override
  State<BookMarkView> createState() => _BookMarkViewState();
}

bool isLoading = true;
String searchtext = '';

class _BookMarkViewState extends State<BookMarkView> {
  bool loading = false;
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  var response=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    response = await dbHelper.queryAllRowsBookmark();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: titleText),
      body: Column(
        children: [
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
              height: size.height * 0.69,
              color: Colors.transparent,
              child: NewsPortion(size),
            ),
          )
        ],
      ),
    );
  }

  NewsPortion(Size size) {
    return isLoading == true || response.length == 0
        ? Loader()
        : ListView.builder(
            itemCount: response.length,
            itemBuilder: (context, index) {
              //  final item = rss.items![index];
              String title = response[index]['title'];
              String description = response[index]['description'];
              String link = response[index]['link'];
              String date = response[index]['date'];
              String time = response[index]['time'];
              // favlist.add(false);
              return title.toLowerCase().contains(searchtext)
                  ? InkWell(
                      onTap: () {
                        Get.to(NewsDetailView(
                          description: description,
                          link: link,
                          title: title,
                        ));
                      },
                      onLongPress: () async {
                        await deleteBook(title);
                        setState(() {});
                      },
                      child: Container(
                        height: 200,
                        child: Card(
                          color: Colors.grey,
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: headingStyle,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
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
                                              const SizedBox(
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
            });
  }

  Loader() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.teal,
        size: 80,
      ),
    );
  }

  deleteBook(String title) async {
    int count = await db.deleteSingleBookMark(title);
    if (count != null) {
      // ignore: use_build_context_synchronously
      snackBar(context, 'Deleted Successfully', 'OK');
    await loadData();
    }
  }
}

Text titleText = Text(
  "Book Mark News....",
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
