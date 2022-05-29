import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/MainView/home_view.dart';

import 'package:path_provider/path_provider.dart';

import 'Entertainment/entertainment_channels.dart';
import 'Politics/politics.dart';
import 'Sports/sports.dart';
import 'heath.dart/healthchannels.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleText,
            Container(
              width: 100,
              child: FlatButton(
                color: Colors.white,
                onPressed: (){
                  Get.to(HomeView());
                },
                child: Text('Done' ),
              ),
            )
          ],
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(children: [
            Expanded(
                child: PortionCategory('Politics', 'Latest News Updates',
                    Icons.newspaper, Politics())),
            Expanded(
                child: PortionCategory('Sports', 'Latest Suports News',
                    Icons.sports_football, const Sports())),
            Expanded(
                child: PortionCategory(
              'Health',
              'Weather News Alerts',
              Icons.shower,
              const HealthChannels(),
            )),
            Expanded(
                child: PortionCategory('Entertainment', 'Entertain your mind',
                    Icons.games, const EntertainmentChannels())),
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
            trailing: GestureDetector(
                onTap: () async {
                  Get.to(whereMove);
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.teal,
                  size: 25,
                )),
            // trailing: InkWell(
            //    onTap: (){
            //    Get.to(whereMove);
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
    );
  }
}

Text titleText = Text(
'Please Select Your Intrest..',
  style: GoogleFonts.josefinSans(
      fontSize: 15, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
