import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:water_tracking_app/Screens/all_pages.dart';
import 'package:water_tracking_app/Screens/homepage/functions/bmifunctions.dart';
import 'package:water_tracking_app/Screens/homepage/widgets/appbar.dart';
import 'package:water_tracking_app/Screens/homepage/widgets/appdrawer.dart';
import 'package:water_tracking_app/Screens/homepage/widgets/glassaddbutton.dart';
import 'package:water_tracking_app/Screens/homepage/widgets/maincard.dart';
import 'package:water_tracking_app/db/functions/db_functions.dart';
import 'package:water_tracking_app/main.dart';
import 'package:water_tracking_app/model/stepcount_model.dart';

final ValueNotifier<String> selectedItemNotifier = ValueNotifier<String>('1');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double percentage = 0;
  incrementPercentage() {
    setState(() {
      percentage += 0.1;
      if (percentage >= 1.0) {
        percentage = 1.0;
        if (percentage == 1.0) {
          archivePopup(context);
        }
      }
      HiveDb().updateGlassPercentage(percentage);
    });
  }

  decrementPercentage() {
    setState(() {
      percentage -= 0.1;
      if (percentage < 0.0) {
        percentage = 0.0;
      }
      HiveDb().updateGlassPercentage(percentage);
    });
  }

  @override
  void initState() {
    loadglasscountHive();
    loadglasspercent();
    super.initState();
  }

  loadglasscountHive() async {
    HiveDb db = HiveDb();
    Box<UserstepdataModel> glassCountBox =
        await Hive.openBox<UserstepdataModel>(db.stepCountBoxKey);
    UserstepdataModel? model = glassCountBox.get('UserDetailsTracking');
    if (model != null) {
      selectedItemNotifier.value = model.waterglass; // Parse as a string
    }
  }

  loadglasspercent() async {
//  Box<UserstepdataModel> glassPercentBox = Hive.box<UserstepdataModel>('STEPCOUNTBOX');
    Box<UserstepdataModel> glassPercentBox =
        await Hive.openBox<UserstepdataModel>(HiveDb().stepCountBoxKey);
    UserstepdataModel? model = glassPercentBox.get('UserDetailsTracking');
    if (model != null) {
      setState(() {
        percentage = model.glasspercent as double;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserImg();
    getUserDatas();
    TimeOfDay time = TimeOfDay.now();
    String amPm = time.hour >= 12 ? 'PM' : 'AM'; // check if it's AM or PM
    ValueNotifier<String> formattedTime =
        ValueNotifier('${time.hourOfPeriod} : ${time.minute} $amPm');
    Timer.periodic(const Duration(seconds: 1), (timer) {
      time = TimeOfDay.now();
      formattedTime.value = '${time.hourOfPeriod} : ${time.minute} $amPm';
    });
    return Scaffold(
      appBar: const HomeAppbar(),
      drawer: AppDrawer(
        userName: userName,
        userEmail: userEmail,
        imgPath: imgPath,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            MainCard(
                formattedTime: formattedTime,
                selectedItemNotifier: selectedItemNotifier),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CircularPercentIndicator(
                    radius: 80,
                    lineWidth: 18.0,
                    percent: percentage,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      '${(percentage * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    progressColor: Colors.lightBlueAccent.shade100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: SizedBox(
                    height: 120, // set the desired height
                    width: 120, // set the desired width
                    child: Card(
                      elevation: 3,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Target',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  ValueListenableBuilder(
                                    valueListenable: selectedItemNotifier,
                                    builder: (context, value, child) {
                                      return Text(
                                        '${(int.parse(value) * 200)}ml',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              AddGlassButton(
                  decrementPercentage: decrementPercentage,
                  incrementPercentage: incrementPercentage),
            ]),
            const SizedBox(height: 30),
            Text(
              'You got ${(percentage * 100).toStringAsFixed(0)}% of today’s goal, keep',
              style: const TextStyle(color: Colors.grey),
            ),
            const Text('focus on your health!',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
