import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Categories/Politics/InternationalChannels/bbc_channel.dart';
import 'package:news_portal/View/Categories/Politics/InternationalChannels/newtimes_channel.dart';
import 'package:news_portal/View/Categories/Politics/InternationalChannels/thewest_channel.dart';

import '../../../../Model/sqlitedbprovider.dart';
import '../../../Common Widgets/snackbar.dart';

class InterNationalNews extends StatefulWidget {
  const InterNationalNews({Key? key}) : super(key: key);

  @override
  State<InterNationalNews> createState() => _InterNationalNewsState();
}

DatabaseHelper db = DatabaseHelper.instance;
class _InterNationalNewsState extends State<InterNationalNews> {

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
                PortionCategory('The West Channel', 'Top USA News',
                'images/westnews.jpg', 'https://thewest.com.au/rss' , 0),
                 SizedBox(height: size.height * 0.05),
            PortionCategory('New Times Channel', 'Top 20 Countries News',
                'images/newtimes.png',  'https://rss.nytimes.com/services/xml/rss/nyt/World.xml', 1),
                SizedBox(height: size.height * 0.05),
            PortionCategory('BBC Channel', 'Fast Update on the news',
                'images/bbc.png',  'http://feeds.bbci.co.uk/news/england/london/rss.xml', 2),


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
  "National Channels",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
