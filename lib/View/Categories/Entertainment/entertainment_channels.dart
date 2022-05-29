import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Categories/Entertainment/zeetv.dart';

import '../../../Model/sqlitedbprovider.dart';
import '../../Common Widgets/snackbar.dart';
import 'geo_entertainment.dart';

class EntertainmentChannels extends StatefulWidget {
  const EntertainmentChannels({Key? key}) : super(key: key);

  @override
  State<EntertainmentChannels> createState() => _EntertainmentChannelsState();
}

DatabaseHelper db = DatabaseHelper.instance;
List<bool> isAdded = [false, false, false];

class _EntertainmentChannelsState extends State<EntertainmentChannels> {
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
                PortionCategory('Geo EnterTainment', 'Pakistani latest News',
                'images/geo.png', 'https://www.geo.tv/rss/1/5', 0),
                 SizedBox(height: size.height * 0.05),
            PortionCategory('Zee TV', 'All Punjab news',
                'images/zeetv.png', 'https://www.geo.tv/rss/1/53', 1),
            //     SizedBox(height: size.height * 0.05),
            // PortionCategory('The News', 'Fast Update on the news',
            //     'images/the news.jpg', TheNewsChannel()),


          ]),
        ),
      ),
    );
  }

  //_________________________________________ListTile
  PortionCategory(
      String ttl, String subttl, String imgurl, String link, int index) {
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
              child: Image.asset(
                imgurl,
                height: 35,
              ),
            ),
            title: Text(
              ttl,
              style: headingStyle,
            ),
            subtitle: Text(
              subttl,
              style: subHeadingStyle,
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
            trailing: Container(
              width: 50,
              child: FlatButton(
                color: isAdded[index] == false ? Colors.teal : Colors.redAccent,
                onPressed: () async {
                  Map<String, dynamic> data = {'title': ttl, 'link': link};
                  await db.insertIntrest(data);
                  // snackBar(context, 'Added Intrest', 'OK');
                },
                child: isAdded[index] == false
                    ? InkWell(
                  onTap: () {
                    addIntrest(ttl, link);
                    setState(() {
                      isAdded[index] = true;
                    });
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
                    : InkWell(
                  onTap: () {
                    deleteIntrest(ttl, link);
                    setState(() {
                      isAdded[index] = false;
                    });
                  },
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //______________________________________________INSERT ITEM FUNCTION
  addIntrest(String title, String link) async {
    var data = {'title': title, 'link': link};
    int? id = await db.insertIntrest(data);
    if (id != null) {
      snackBar(context, 'Intrest Added', 'OK');
    }
  }

  //_____________________________________________DELETE ITEM FUNVTION
  deleteIntrest(String title, String link) async {
    int? id = await db.deleteIntrest(title, link);
    if (id != null) {
      print(id);
      snackBar(context, 'Remove Intrest', 'OK');
    }
  }
}

Text titleText = Text(
  "EnterTainments Channels",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
