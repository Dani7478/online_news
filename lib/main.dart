import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:news_portal/View/MainView/main_view.dart';
import 'package:news_portal/View/MainView/splash_view.dart';
import 'Model/sqlitedbprovider.dart';


void main() {
  DatabaseHelper db = DatabaseHelper.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Portal',
      theme: ThemeData(
       
        primarySwatch: Colors.teal,
      ),
      home:const SplashView()
    );
  }
}

