import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Categories/Politics/InternationalChannels/bbc_channel.dart';
import 'package:news_portal/View/Categories/Politics/InternationalChannels/newtimes_channel.dart';
import 'package:news_portal/View/Categories/Politics/InternationalChannels/thewest_channel.dart';

class InterNationalNews extends StatelessWidget {
  const InterNationalNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: titleText,
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                PortionCategory('The West Channel', 'Top USA News',
                'images/westnews.jpg', TheWestChannel()),
                 SizedBox(height: size.height * 0.05),
            PortionCategory('New Times Channel', 'Top 20 Countries News',
                'images/newtimes.png', NewTimesChannel()),
                SizedBox(height: size.height * 0.05),
            PortionCategory('BBC Channel', 'Fast Update on the news',
                'images/bbc.png', BBCChannel()),
           
        
          ]),
        ),
      ),
    );
  }
  //_________________________________________ListTile

  PortionCategory(String ttl, String subttl, String imgurl, dynamic whereMove) {
    return Container(
      height: 120,
      child: Card(
        elevation: 15,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListTile(
            leading: CircleAvatar(
              //backgroundColor: primaryColor,
              // foregroundColor: primaryColor,
              backgroundColor: Colors.transparent,
              radius: 30,
             // child: Icon(icn, color: Colors.white),
             child: Image.asset(imgurl, height: 35,),
            ),
            title: Text(
              ttl,
              style: headingStyle,
            ),
            subtitle: Text(
              subttl,
              style: subHeadingStyle,
            ),
            trailing: InkWell(
              onTap: () {
                Get.to(whereMove);
              },
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.teal,
                size: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Text titleText = Text(
  "National Channels",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
