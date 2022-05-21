import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webfeed/webfeed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../news_detail.dart';

class GeoNewsChannel extends StatefulWidget {
  @override
  State<GeoNewsChannel> createState() => _GeoNewsChannelState();
}

class _GeoNewsChannelState extends State<GeoNewsChannel> {
  bool isAdVisible = true;
  bool isLoading = false;
  late RssFeed rss = RssFeed();
   String internet='connected';

  @override
  void initState() {
    checkInternetConnection();
    
     super.initState();
  }

  checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        internet = 'connected';
        setState(() {});
      }
    } on SocketException catch (_) {
      print('not connected');
      internet = 'disconnected';
      setState(() {});
    }
     loadData();
  }

  loadData() async {
    print('loading');
    if (internet == 'connected') {
      try {
        setState(() {
          isLoading = true;
        });
        const API = 'https://www.geo.tv/rss/1/1';
        final response = await get(Uri.parse(API));
        final File file = File('Files/geonews.txt');
        await file.writeAsString(response.body);
        var channel = RssFeed.parse(response.body);
        setState(() {
          rss = channel;
          isLoading = false;
        });
      } catch (err) {
        throw err;
      }
    } if (internet == 'disconnected') {
      String body = await _read();
      print(body);
    }
  }

  Future<String> _read() async {
    late String body;
    try {
      final File file = File('Files/geonews.txt');
      body = await file.readAsString().toString();
    } catch (e) {
      print("Couldn't read file");
    }
    return body;
  }

  @override
  Widget build(BuildContext context) {
    const transitionType = ContainerTransitionType.fadeThrough;

    return Scaffold(
      appBar: AppBar(
        title: titleText,
        backgroundColor: primaryColor,
        actions: <Widget>[
          MaterialButton(
              onPressed: () => loadData(),
              child: Row(
                children: const [
                  Icon(
                    Ionicons.refresh_circle,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Refresh')
                ],
              ))
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          isLoading == false
              ? ListView.builder(
                  itemCount: rss.items!.length,
                  itemBuilder: (BuildContext context, index) {
                    final item = rss.items![index];

                    String ttl = item.title.toString();
                    String author = item.pubDate.toString();
                    String date = DateFormat('MMM dd yyyy')
                        .format(DateTime.parse(item.pubDate.toString()));
                    String image = item.description.toString().split('"')[1];
                    String description =
                        item.description.toString().split('>')[1].trim();
                    print(description);
                    String link = item.link.toString();
                    //   final creator= item.dc!.creator;
                    //  print(creator);
                    return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: PortionCategory(
                            image,
                            ttl,
                            date,
                            Icons.newspaper,
                            NewsDetailScreen(
                              image: image,
                              title: ttl,
                              link: link,
                              description: description,
                            )));
                  })
              :
              //  Center(
              //     child: CircularProgressIndicator(),
              // ),
              loading(),
        ],
      ),
    );
  }
  //_________________________________________ListTile

  PortionCategory(String imgurl, String ttl, String subttl, IconData icn,
      dynamic whereMove) {
    return InkWell(
      onTap: () {
        Get.to(whereMove);
      },
      child: Container(
        height: 200,
        child: Card(
          elevation: 15,
          child: Align(
            alignment: Alignment.centerLeft,
            child: ListTile(
              leading: Container(
                  child: Image(image: CachedNetworkImageProvider(imgurl))),
              title: Text(
                ttl,
                style: headingStyle,
                textAlign: TextAlign.start,
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    subttl,
                    style: subHeadingStyle,
                  ),
                ],
              ),
              // trailing: InkWell(
              //   onTap: () {
              //     Get.to(whereMove);
              //   },
              //   child: const Icon(
              //     Icons.arrow_forward,
              //     color: Colors.teal,
              //     size: 25,
              //   ),
              // ),
            ),
          ),
        ),
      ),
    );
  }

  loading() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.teal,
        size: 80,
      ),
    );
  }
}

Text titleText = Text(
  "Geo News Feed",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
