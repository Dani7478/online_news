import 'package:flutter/material.dart';

import '../../Model/sqlitedbprovider.dart';

class ScheduleDetail extends StatefulWidget {
  ScheduleDetail({Key? key, required this.day}) : super(key: key);
  String day;

  @override
  State<ScheduleDetail> createState() => _ScheduleDetailState();
}

class _ScheduleDetailState extends State<ScheduleDetail> {
  DatabaseHelper db = DatabaseHelper.instance;
  List DayDetailList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDayDetail();
  }

  getDayDetail() async {
    DayDetailList = await db.getFilterSchedleNews(widget.day.toLowerCase());
    print(DayDetailList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.day.toUpperCase()} Detail',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: DayDetailList.length,
          itemBuilder: (context, index) {
            String channel = DayDetailList[index]['channel'];
            String stime = DayDetailList[index]['stime'];
            String etime = DayDetailList[index]['etime'];
            return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                      color: Colors.tealAccent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: Center(
                    child: ListTile(
                      leading: const Icon(
                        Icons.schedule,
                        size: 40,
                        color: Colors.black,
                      ),
                      title: Text(
                        channel,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                      subtitle: Text(
                        '$stime----$etime',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ));
          }),
    );
  }
}
