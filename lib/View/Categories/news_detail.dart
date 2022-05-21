import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  NewsDetailScreen(
      {Key? key,
      required this.image,
      required this.title,
      required this.link,
      required this.description})
      : super(key: key);

  String image;
  String title;
  String link;
  String description;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: titleText,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            children: [
              // Container(
              //   width: size.width,
              //   height: size.height * 0.4,
              //   //color: Colors.teal,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: NetworkImage(widget.image),
              //       fit: BoxFit.fill,
              //     ),
              //   ),
              //   //child: Image(image: CachedNetworkImageProvider(widget.image))
              // ),
              Container(
                  child: Column(
                children: [
                  SizedBox(height:size.height*0.02),
                  // Align(
                  //     alignment: Alignment.topLeft,
                  //     child: Text(
                  //       "News Title",
                  //       style: headingStyle,
                  //     )),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.title,
                        style: headingStyle,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                   Align(
                      alignment: Alignment.topLeft,
                     
                     child: Html(
                    data: widget.description,
                  ),
                      ),
                      SizedBox(height: 5,),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Visit Link for more detail",
                        style: headingStyle,
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SelectableLinkify(
                      onOpen: _onOpen,
                      text: widget.link,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                 
                ],
              ))
            ],
          ),
        )),
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}

Text titleText = Text(
  "News Detail",
  style: GoogleFonts.josefinSans(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
);
Color primaryColor = Colors.teal;

TextStyle headingStyle = GoogleFonts.josefinSans(
    fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle subHeadingStyle = GoogleFonts.josefinSans(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
