// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_portal/View/Authentication/login_view.dart';
import 'package:news_portal/View/Common%20Widgets/snackbar.dart';
import 'package:news_portal/View/MainView/main_view.dart';

import '../../Model/sqlitedbprovider.dart';
import '../Bookmark/bookmark_view.dart';

class ScheduleView extends StatefulWidget {
  ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  bool _isLoading = false;
  List<String> daysList = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturdy',
    'sunday'
  ];

  List<String> timeList = [
    '9:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
    '23:00',
    '1:00',
    '2:00',
    '3:00',
    '4:00',
    '5:00',
    '6:00',
    '7:00',
    '8:00'
  ];
  final List<String> _selectedStartTime = [];
  final List<String> _selectedEndTime = [];
  List<String> channelList = [];
  final List<bool> _isChecked = [];
  List<bool> isExpanded = [false, false, false, false, false, false, false];

//__________________________________________INIT STATE
  @override
  void initState() {
    super.initState();
    callFunctions();
  }

  callFunctions() async {
    await getChannels();
  }

//__________________________________________GET CHANNELS
  getChannels() async {
    print('Geting Channels From DB.............');
    List list = await db.getAllIntrestRows();
    print('Total List ${list.length}');
    fillChannelList(list);
  }

  fillChannelList(List list) async {
    print('Filling Channel List.............');
    for (int i = 0; i < list.length; i++) {
      channelList.add(list[i]['title']); // geo news  lahore the news
      _isChecked.add(false);
      _selectedStartTime.add('9:00');
      _selectedEndTime.add('12:00');
    }
    _isLoading = true;
    setState(() {});
  }

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
                  onPressed: () {
                    Get.to(const MainScreen());
                  },
                  child: const Text('Done'),
                ),
              )
            ],
          ),
          backgroundColor: primaryColor,
        ),
        body: _isLoading == true
            ? ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  double hite = 80;
                  var icon = const Icon(
                    Icons.arrow_circle_right,
                    color: Colors.white,
                    size: 40,
                  );
                  if (isExpanded[index] == true) {
                    icon = const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.white,
                      size: 40,
                    );
                    hite = size.height - 300;
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Container(
                        height: hite,
                        width: double.infinity,
                        color: Colors.teal,
                        child: Align(
                          alignment: isExpanded[index] == false
                              ? Alignment.centerLeft
                              : Alignment.topLeft,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  daysList[index].toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                trailing: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isExpanded[index]) {
                                          isExpanded[index] = false;
                                        } else {
                                          isExpanded[index] = true;
                                        }
                                      });
                                    },
                                    child: icon),
                              ),
                              isExpanded[index] == true
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 200,
                                          child: ListView.builder(
                                              itemCount: channelList.length,
                                              itemBuilder: (context, index1) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Checkbox(
                                                          value: _isChecked[
                                                              index1],
                                                          onChanged: (value) {
                                                            _isChecked[index1] =
                                                                value!;
                                                            setState(() {});
                                                          }),
                                                    ),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          channelList[index1],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        )),
                                                    Expanded(
                                                      flex: 2,
                                                      child: DropdownButton(
                                                        value:
                                                            _selectedStartTime[
                                                                index1],
                                                        items: timeList.map(
                                                            (String items) {
                                                          return DropdownMenuItem(
                                                              value: items,
                                                              child: Text(
                                                                items,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ));
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          _selectedStartTime[
                                                                  index1] =
                                                              value.toString();
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: DropdownButton(
                                                        value: _selectedEndTime[
                                                            index1],
                                                        items: timeList.map(
                                                            (String items) {
                                                          return DropdownMenuItem(
                                                              value: items,
                                                              child: Text(
                                                                items,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ));
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          _selectedEndTime[
                                                                  index1] =
                                                              value.toString();
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          color: Colors.white,
                                          height: 50,
                                          width: double.infinity,
                                          child: MaterialButton(
                                            onPressed: () async {
                                              db.deleteSingleSchedle(
                                                  daysList[index]);
                                              await submiteSchedle(
                                                  daysList[index]);
                                            },
                                            child: const Text(
                                              'Schedule',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        )),
                  );
                })
            : const Center(child: CircularProgressIndicator()));
  }

  //___________________________________SUBMIT SCHEDLE FUNCTION
  submiteSchedle(String day) async {
    for (int i = 0; i < channelList.length; i++) {
      if (_isChecked[i] == true) {
        var row = {
          'day': day,
          'channel': channelList[i],
          'stime': _selectedStartTime[i],
          'etime': _selectedEndTime[i]
        };
        print(row);
        int id = await db.insertSchedle(row);
        if (id != null) {
          // ignore: use_build_context_synchronously
          snackBar(context, 'Feed Schedle for $day', 'OK');
        }
      }
    }
  }
}

Text titleText = Text(
  'Schedle Your Feed...',
  style: GoogleFonts.josefinSans(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800),
);
