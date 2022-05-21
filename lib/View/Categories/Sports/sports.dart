import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


import 'Cricket/cricket_channels.dart';
import 'Football/football_channels.dart';

class Sports extends StatelessWidget {
  const Sports({Key? key}) : super(key: key);

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
            PortionCategory('FootBall', 'Latest Footbal Detail',
                Icons.sports_baseball ,const FootBallChannels()),
            SizedBox(height: size.height * 0.05),
            PortionCategory('Cricket', 'Latest Cricket Detail',
                Icons.sports_cricket, const CricketChannels()),
            // SizedBox(height: size.height * 0.05),
            // PortionCategory('Hocky', 'Latest Hocky Detail',
            //     Icons.sports_hockey_rounded, const InterNationalNews()),
          ]),
        ),
      ),
    );
  }
  //_________________________________________ListTile

  PortionCategory(String ttl, String subttl, IconData icn, dynamic whereMove) {
    return Container(
      height: 120,
      child: Card(
        elevation: 15,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor,
              // foregroundColor: primaryColor,
              radius: 30,
              child: Icon(icn, color: Colors.white),
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
  "Sports News Feed",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
