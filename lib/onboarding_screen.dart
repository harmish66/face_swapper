import 'package:ai_headshots/screen_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  List<OnboardingScreen> pages = [];
  bool pressGeoON = false;
  bool cmbscritta = false;
  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                pressGeoON = !pressGeoON;
                cmbscritta = !cmbscritta;
              });
            },
            controller: _controller,
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage("assets/sc_1/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    SizedBox(
                      height: 400.h,
                    ),
                    Image.asset(
                      "assets/sc_1/sub_text.png",
                      width: 800.h,
                    ),
                    SizedBox(height: 40.h),
                    Image.asset("assets/sc_1/Generator of AI headshots.png",
                        width: 550.h),
                  ],
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage("assets/sc_2/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    SizedBox(
                      height: 400.h,
                    ),
                    Image.asset(
                      "assets/sc_2/sub_text.png",
                      width: 650.h,
                    ),
                    SizedBox(height: 40.h),
                    Image.asset("assets/sc_2/Take a look.png", width: 300.h),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment(0,0.35),
            child: SmoothPageIndicator(controller: _controller, count: 2,effect: const SlideEffect(
              activeDotColor: Colors.white54,
              dotHeight: 10,
              dotColor: Colors.blue,
              dotWidth: 10,
            ),),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 150.h,
                  width: 850.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: cmbscritta ? Text("Done",style: TextStyle(fontSize: 20,color: Colors.white),) : Text("Next",style: TextStyle(fontSize: 20,color: Colors.white),),
                    onPressed: () async {

                      if(_controller.page!.toInt() != 1 ){
                        _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                      }else{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool("isIntroScreenOpened", true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Screen_1()));
                      }
                    },
                  ),
                ),
                SizedBox(height: 150.h,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
