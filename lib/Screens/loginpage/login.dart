
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracking_app/Screens/all_pages.dart';
import 'package:water_tracking_app/Screens/intro3.dart';
import 'package:water_tracking_app/Screens/loginpage/widgets/textfield.dart';
import 'package:water_tracking_app/Screens/signuppage/signup.dart';
import 'package:water_tracking_app/db/functions/db_functions.dart';
import 'package:water_tracking_app/main.dart';
import 'package:water_tracking_app/model/data_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _obscureText = ValueNotifier<bool>(true);

  final _formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    _obscureText.value = !_obscureText.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const Intro3(),
                        ));
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      'LOGIN',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Securely login to your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Emailfield(
                  Controller: _emailController,
                  Hinttext: 'Enter your email',
                  warning: 'Email is required'),
              Passwordfield(
                  Controller: _passwordController,
                  Hinttext: 'Enter your password',
                  warning: 'Password required',
                  obscureText: _obscureText,
                  passwordvisibility: togglePasswordVisibility),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 340.0,
                    height: 60.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent.shade100,
                      ),
                      child: const Text('LOG IN'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create An Account',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => const Singnup()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('By clicking Continue, you agree to our'),
                  Text(
                    'Terms of Service',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('and'),
                  SizedBox(height: 40),
                  Text(
                    ' Privacy Policy',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    HiveDb db = HiveDb();
    Box userBox = await Hive.openBox(db.userBoxKey);

    UserdataModal? user = await userBox.get(email);

    if (user != null) {
      if (password == user.password) {
        final sharedPrefs = await SharedPreferences.getInstance();
        await sharedPrefs.setString(email_key_Name, email);
        await sharedPrefs.setBool(Save_key_Name, true);

        // Clear the navigation stack and push the MainPage
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const MainPage()),
        );
        // Get.to(() => MainPage());
      } else {
        Get.snackbar('Password is wrong', '');
      }
    } else {
      print('Existing emails');
      print(userBox.keys);
      Get.snackbar('User does not exist', '');
    }
  }
}
