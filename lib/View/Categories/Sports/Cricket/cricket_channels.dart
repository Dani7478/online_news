import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Categories/Sports/Cricket/espn_aus.dart';
import 'package:news_portal/View/Categories/Sports/Cricket/espn_ind.dart';
import 'package:news_portal/View/Categories/Sports/Cricket/espn_pak.dart';

import '../../../../Model/sqlitedbprovider.dart';
import '../../../Common Widgets/snackbar.dart';

class CricketChannels extends StatefulWidget {
  const CricketChannels({Key? key}) : super(key: key);

  @override
  State<CricketChannels> createState() => _CricketChannelsState();
}

DatabaseHelper db = DatabaseHelper.instance;


class _CricketChannelsState extends State<CricketChannels> {

  List<bool> isAdded = [false, false, false];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isAdded = [false, false, false];
  }

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
                PortionCategory('EspnCric Info Aus', 'Latest Football news',
                'images/ESPNCricinfo.png','https://www.espncricinfo.com/rss/content/story/feeds/2.xml',0),
                 SizedBox(height: size.height * 0.05),
            PortionCategory('EspnCric Info Ind ', 'Latest Football news',
                'images/ESPNCricinfo.png','https://www.espncricinfo.com/rss/content/story/feeds/6.xml',1),
                SizedBox(height: size.height * 0.05),
            PortionCategory('EspnCric Info Pak', 'Fast Update on the news',
                'images/ESPNCricinfo.png','https://www.espncricinfo.com/rss/content/story/feeds/7.xml',2),


          ]),
        ),
      ),
    );
  }

  //_________________________________________ListTile
  PortionCategory(String ttl, String subttl, String imgurl,
      String link, int index) {
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
                color:isAdded[index] == false ? Colors.teal : Colors.redAccent,
                onPressed: () async {
                  Map<String, dynamic> data = {'title': ttl, 'link': link};
                  await db.insertIntrest(data);
                  // snackBar(context, 'Added Intrest', 'OK');
                },
                child: isAdded[index] == false
                    ? InkWell(
                  onTap: () {
                    addIntrest(ttl,link);
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

  addIntrest(String title, String link) async {
    var data ={
      'title':title,
      'link':link
    };
    int? id = await db.insertIntrest(data);
    if(id!=null)
    {
      snackBar(context, 'Intrest Added', 'OK');
    }

  }

  deleteIntrest(String title, String link) async {

    int? id = await db.deleteIntrest(title, link);
    if(id!=null)
    {
      print(id);
      snackBar(context, 'Remove Intrest', 'OK');
    }

  }
}

Text titleText = Text(
  "Cricket Channels",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
