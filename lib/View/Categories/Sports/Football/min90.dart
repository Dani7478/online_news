import 'dart:async';
import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:webfeed/webfeed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../news_detail.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Mint90Channel extends StatefulWidget {
  @override
  State<Mint90Channel> createState() => _Mint90ChannelState();
}

class _Mint90ChannelState extends State<Mint90Channel> {
  bool isAdVisible = true;
  bool isLoading = false;
  late RssFeed rss = RssFeed();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      const API = 'https://www.90min.com/posts.rss';
      final response = await get(Uri.parse(API));
      var channel = RssFeed.parse(response.body);
      setState(() {
        rss = channel;
        isLoading = false;
      });
    } catch (err) {
      throw err;
    }
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
                    String image =item.media!.thumbnails![0].url.toString();
                   
                    String description = item.description.toString();
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
  "90 Times Channel",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
