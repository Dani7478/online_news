import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/View/Authentication/login_view.dart';
import 'package:news_portal/View/Categories/Startup.dart';
import 'package:news_portal/View/History/scheduleDetail.dart';
import '../../Model/sqlitedbprovider.dart';
import '../Schedule/schedule_view.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  DatabaseHelper db = DatabaseHelper.instance;
  List interstList = [];
  List scheduleList = [];
  List<String> daysList = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturdy',
    'sunday'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllIntrest();
    getAllSchedule();
  }

  getAllIntrest() async {
    interstList = await db.getAllIntrestRows();
    print(interstList);
  }

  getAllSchedule() async {
    scheduleList = await db.getAllSchedle();
    print(scheduleList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: heading,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget('Selected Channels'),
                    editButton('change', 1),
                  ],
                ),
              ),
              dividerLine(),
              showChannel(),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget('Scheduling Detail'),
                    editButton('change', 2),
                  ],
                ),
              ),
              dividerLine(),
              showSchedule(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: textWidget('Logout'),
              ),
              dividerLine(),
              logoutButton(),
            ],
          ),
        ),
      ),
    );
  }

//__________________________TEXT HEADING
  textWidget(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600),
    );
  }

//__________________________TEXT HEADING
  editButton(String text, int type) {
    return InkWell(
      onTap: () {
        if (type == 1) {
          db.clearIntrest();
          db.deleteAllSchedle();
          Get.to(const StartupScreen());
        }
        if (type == 2) {
          Get.to(ScheduleView());
        }
      },
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16, color: Colors.teal, fontWeight: FontWeight.w600),
      ),
    );
  }

  //_____________________________DIVIDER
  Padding dividerLine() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(
        height: 5,
        color: Colors.black54,
        thickness: 1.5,
      ),
    );
  }

//____________________________________LOGOUT BUTTON
  logoutButton() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.teal, size: 25),
      title: const Text(
        'Logout',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      trailing: InkWell(
          onTap: () {
            Get.to(const LoginView());
          },
          child: const Icon(
            Icons.subdirectory_arrow_left_outlined,
            color: Colors.teal,
          )),
    );
  }

  showChannel() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
          itemCount: interstList.length,
          itemBuilder: (context, index) {
            // return Row(
            //   children:  [
            //     const Icon(Icons.arrow_forward_sharp, color: Colors.redAccent, size: 20),
            //     const SizedBox(width: 20,),
            //     Text(IntrestList[index]['title'])
            //   ],
            // );
            return ListTile(
              leading:
                  const Icon(Icons.description, color: Colors.teal, size: 25),
              title: Text(
                interstList[index]['title'],
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            );
          }),
    );
  }

//______________________________________________SHOW SCHEDULE
  showSchedule() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
          itemCount: daysList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.schedule, color: Colors.teal, size: 25),
              title: Text(
                daysList[index].toUpperCase(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              trailing: InkWell(
                  onTap: () {
                    Get.to(ScheduleDetail(day: daysList[index]));
                  },
                  child: const Icon(Icons.arrow_forward_ios)),
            );
          }),
    );
  }
}

Widget heading = const Text(
  'Your History Is Always Saved',
  style:
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
);
