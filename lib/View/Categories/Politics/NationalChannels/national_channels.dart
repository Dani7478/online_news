import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Categories/Politics/NationalChannels/geonews_channel.dart';
import 'package:news_portal/View/Categories/Politics/NationalChannels/lahorenews_channel.dart';
import 'package:news_portal/View/Categories/Politics/NationalChannels/thenews_channel.dart';


class NationalNews extends StatelessWidget {
  const NationalNews({Key? key}) : super(key: key);

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
                PortionCategory('Geo News', 'Pakistani latest News',
                'images/geo.png', GeoNewsChannel()),
                 SizedBox(height: size.height * 0.05),
            PortionCategory('Lahore News', 'All Punjab news',
                'images/lahore.png', LahoreNewsChannel()),
                SizedBox(height: size.height * 0.05),
            PortionCategory('The News', 'Fast Update on the news',
                'images/the news.jpg', TheNewsChannel()),
           
        
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
