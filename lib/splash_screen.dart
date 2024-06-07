import 'dart:async';

import 'package:ai_headshots/screen_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isIntroScreenOpened = prefs.getBool("isIntroScreenOpened") ?? false;
      if (isIntroScreenOpened) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Screen_1()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("assets/splash/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, right: 15, left: 15, bottom: 30),
                  child: Image.asset(
                    "assets/splash/bottum_box.png",
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    SizedBox(
                      height: 200.h,
                    ),
                    Container(
                      height: 115.h,
                      width: 800.w,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(seconds: 5),
                          curve: Curves.easeInOut,
                          tween: Tween<double>(
                            begin: 0,
                            end: 1,
                          ),
                          builder: (context, value, _) =>
                              LinearProgressIndicator(
                                value: value,
                                color: Colors.blue,
                                backgroundColor: Colors.black12,
                                borderRadius: BorderRadius.circular(25),
                              ),
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/splash/sub_text.png",
                      width: 650.h,
                    ),
                    SizedBox(height: 40.h),
                    Image.asset("assets/splash/app_name.png", width: 300.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
