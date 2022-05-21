// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Testing extends StatelessWidget {
//   const Testing({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size size=MediaQuery.of(context).size;
//     return Scaffold(
//       body: ListView.builder(
//           itemCount: 20,
//           itemBuilder: (context, index) {
//             return Container(
//               height: 200,
//               child: Card(
//                 color: Colors.grey,
//                 elevation: 20,
//                 child: Row(children: [
//                   CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: Center(
//                         child: Text(
//                       '# ${index + 1}',
//                       style: numberStyle,
//                     )),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                     child: Container(
//                       width: size.width*0.6,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Shahbaz shreef meet with imran khan about election 2022 pm nigran',
//                             style: headingStyle,
//                           ),

//                           SizedBox(height: 20,),

//                            Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   if (favlist[index] == false) {
//                                     favlist[index] = true;
//                                     setState(() {});
//                                   } else {
//                                     favlist[index] = false;
//                                     setState(() {});
//                                   }
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Image.asset(
//                                       'images/heart.png',
//                                       height: 20,
//                                       color: favlist[index] == true
//                                           ? Color.fromARGB(255, 248, 55, 71)
//                                           : Colors.black,
//                                     ),
//                                     Text('Like',
//                                         style: GoogleFonts.josefinSans(
//                                             color: favlist[index] == true
//                                                 ? Color.fromARGB(
//                                                     255, 248, 55, 71)
//                                                 : Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15)),
//                                   ],
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {},
//                                 child: Row(
//                                   children: [
//                                     Image.asset('images/comment.png',
//                                         height: 20),
//                                     Text('Bookmark',
//                                         style: GoogleFonts.josefinSans(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15))
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),


//                         ],
//                       ),
//                     ),
//                   )
//                 ]),
//               ),
//             );
//           }),
//     );
//   }
// }

// Text titleText = Text(
//   "Trending News",
//   style: GoogleFonts.josefinSans(
//       fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800),
// );
// Color primaryColor = Colors.teal;

// TextStyle headingStyle = GoogleFonts.josefinSans(
//     fontSize: 18, color: Colors.black, fontWeight: FontWeight.w900);
// TextStyle subHeadingStyle = GoogleFonts.josefinSans(
//     fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);

// TextStyle internetStyle = GoogleFonts.josefinSans(
//     fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700);

// TextStyle numberStyle = GoogleFonts.josefinSans(
//     fontSize: 20,
//     color: Color.fromARGB(255, 247, 28, 13),
//     fontWeight: FontWeight.w900);
