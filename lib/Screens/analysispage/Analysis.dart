import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:water_tracking_app/Screens/History_page.dart';
import 'package:water_tracking_app/Screens/analysispage/widgets/analysiscontainer.dart';
import 'package:water_tracking_app/Screens/step_tracker.dart';
import 'package:water_tracking_app/db/functions/db_functions.dart';
import 'package:water_tracking_app/model/stepcount_model.dart';

class Analysispage extends StatefulWidget {
  const Analysispage({Key? key}) : super(key: key);

  @override
  State<Analysispage> createState() => AnalysispageState();
}

class AnalysispageState extends State<Analysispage> {
  String calorieCount = '0';
  getCaloriecount() async {
    HiveDb db = HiveDb();
    Box<UserstepdataModel> stepCalorieBox =
        await Hive.openBox<UserstepdataModel>(db.stepCountBoxKey);
    UserstepdataModel model = stepCalorieBox.get('UserDetailsTracking')!;
    setState(() {
      calorieCount = model.caloriesBurnedToday;
    });
  }

  @override
  Widget build(BuildContext context) {
    getCaloriecount();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    'For Today',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const AnalysisPageCardes(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const StepTracker(),
                        ),
                      );
                    },
                    child: const Analysiscard(
                        title: 'Walk',
                        image: 'assets/images/Human walk cycle.gif'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      height: 250,
                      width: 160,
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                        // Set the background color to white
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Calories",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            calorieCount,
                            style: TextStyle(
                              color: Colors.lightBlueAccent.shade100,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 50),
                          const Text(
                            "Kcal",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.to(() => const NumericDefault());
                      },
                      child: const Analysiscard(
                          title: 'History',
                          image: 'assets/images/data-analysis.gif')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}