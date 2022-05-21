import 'dart:async';
import 'dart:convert';
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



class TheNewsChannel extends StatefulWidget {
  // const FirstScreen({Key? key, }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final String title;

  @override
  State<TheNewsChannel> createState() => _TheNewsChannelState();
}

class _TheNewsChannelState extends State<TheNewsChannel> {
  /*static BannerAd myBanner = BannerAd(
    adUnitId: InterstitialAd.testAdUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );*/
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

      // This is an open REST API endpoint for testing purposes
      const API = 'https://www.thenews.com.pk/rss/1/1';
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
                children: [Icon(Ionicons.refresh_circle,color: Colors.white,), SizedBox(width: 5,), Text('Refresh')],
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
                    String description=item.description.toString().split('>')[1].trim();
                    print(description);
                   String link=item.link.toString();
                  //   final creator= item.dc!.creator;
                  //  print(creator);
                    return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: PortionCategory(
                            image, ttl, date, Icons.newspaper, NewsDetailScreen(image: image,title: ttl,link: link, description: description,)));
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
      onTap: (){
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

  loading()
  {
  return  
    Center(
      child:  LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.teal,
        size: 80,

      ),
    );
  }
}

Text titleText = Text(
  "The News Feed",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);


  
