import 'dart:io';
import 'package:flutter/material.dart';
import 'package:water_tracking_app/Screens/updatepage/widgets/updatefield.dart';
import 'package:water_tracking_app/db/functions/db_functions.dart';
import 'package:water_tracking_app/main.dart';

class Updateprofile extends StatefulWidget {
  const Updateprofile({super.key});

  @override
  State<Updateprofile> createState() => _UpdateprofileState();
}

final _emailController = TextEditingController();
final _nameController = TextEditingController();
final _ageController = TextEditingController();
final _passwordController = TextEditingController();

class _UpdateprofileState extends State<Updateprofile> {
  late int selectedRadio;
  @override
  void initState() {
    selectedRadio = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadValuesToCtrl(
      ageController: _ageController,
      nameController: _nameController,
      emailController: _emailController,
      passwordController: _passwordController,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 120),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async => await getPhoto(),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: ValueListenableBuilder(
                      valueListenable: imgPath,
                      builder: (BuildContext context, file, _) {
                        return imgPath.value.isEmpty
                            ? Image.asset(
                                'assets/images/pokiman.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(file),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                      },
                    )),
              ),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              UpdateTextfield(
                  controller: _nameController,
                  hintText: 'Enter Your name',
                  warning: 'name is empty'),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              UpdateTextfield(
                  controller: _passwordController,
                  hintText: 'Enter Your new password',
                  warning: 'password is empty'),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Age',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              UpdateTextfield(
                  controller: _ageController,
                  hintText: 'Enter Your age',
                  warning: 'age is empty'),
              const Padding(
                padding: EdgeInsets.only(left: 25),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent.shade100,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    updateUserDetails(_nameController, _passwordController,
                        _ageController, _emailController);
                  },
                  child: const Text('UPDATE')),
            ],
          ),
        ),
      ),
    );
  }
}
