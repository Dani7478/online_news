import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Categories/heath.dart/geo_tv.dart';
import 'package:news_portal/View/Categories/heath.dart/healthresource4u.dart';

class HealthChannels extends StatelessWidget {
  const HealthChannels({Key? key}) : super(key: key);

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
                PortionCategory('Geo Tv', 'Health tips and tricks',
                'images/geo.png', GeoTvChannel()),
                 SizedBox(height: size.height * 0.05),
            PortionCategory('HeathResources4U', 'All Punjab news',
                'images/zeetv.png', HeathResources4U()),
            //     SizedBox(height: size.height * 0.05),
            // PortionCategory('The News', 'Fast Update on the news',
            //     'images/the news.jpg', TheNewsChannel()),
           
        
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
  "Health Channels",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
