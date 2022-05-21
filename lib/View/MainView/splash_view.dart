import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Authentication/login_view.dart';


class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 5),
        () =>Get.to(LoginView()) );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 180,
                  width: 180,
                  //  color: Colors.red,
                  child: Image.asset(
                    'images/mainlogo.png',
                    height: 50,
                  ),
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                  //color: Colors.green,
                  child: Column(
                children: [
                  Text(
                    'NEWS PORATL',
                    style: GoogleFonts.josefinSans(
                        color: Colors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const CircularProgressIndicator(
                    color: Colors.yellow,
                    strokeWidth: 3,
                  ),
                ],
              )))
        ],
      ),
    );
  }
}
