import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webfeed/domain/rss_feed.dart';
import '../../Model/sqlitedbprovider.dart';
import 'package:intl/intl.dart';

class Task1 extends StatefulWidget {
  const Task1({Key? key}) : super(key: key);

  @override
  State<Task1> createState() => _Task1State();
}

bool isAdVisible = true;
bool isLoading = true;
late RssFeed rss = RssFeed();

class _Task1State extends State<Task1> {
  bool internet = true;
  List<bool> favlist = [];
  List<bool> bookmrklist = [];
  List offlineData = [];
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.tealAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: 'Please Enter Link here',
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12)),
                      height: 40,
                      child: TextButton(
                          onPressed: () async {
                            await loadData(searchController.text);
                          },
                          child: const Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )),
                    ),
                  )
                ],
              )),
          Expanded(
              flex: 9,
              child: isLoading == true
                  ? loading()
                  : ListView.builder(
                      itemCount: rss.items!.length,
                      itemBuilder: (context, index) {
                        var item = rss.items![index];
                        String title = item.title.toString();
                        String description = item.description.toString();
                        String link = item.link.toString();
                        String pubDate = item.pubDate.toString();
                        DateTime dateTime = DateTime.parse(pubDate);
                        String date =
                            DateFormat('MMM dd yyyy').format(dateTime);
                        String time =
                            '${dateTime.hour}:${dateTime.minute}'; // 11:46
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Container(
                            height: 150,
                            color: Colors.tealAccent,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Center(
                                    child: Text(
                                  '# ${index + 1}',
                                  style: numberStyle,
                                )),
                              ),
                              title: Text(
                                title,
                                style: headingStyle,
                                textAlign: TextAlign.justify,
                              ),
                              subtitle: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                              ),
                            ),
                          ),
                        );
                      })),
        ],
      )),
    );
  }

//_______________________________________________LOAD DATA
  loadData(String url) async {
    if (internet == true) {
      try {
        final response = await http.get(Uri.parse(url));
        var channel = RssFeed.parse(response.body);
        setState(() {
          rss = channel;
        });
        // ignore: empty_catches
      } catch (err) {}
    }
    // ignore: avoid_print
    print('${rss.items!.length}');
    isLoading = false;
    setState(() {});
  }

  //________________________________CHECK INTERNET
  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      internet = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      internet = true;
    } else {
      internet = false;

      setState(() {});
    }
  }

  //____________________________________LOADER
  loading() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.teal,
        size: 80,
      ),
    );
  }
}

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
