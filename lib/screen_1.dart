import 'package:ai_headshots/screen_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screen_1 extends StatefulWidget {
  const Screen_1({super.key});

  @override
  State<Screen_1> createState() => _Screen_1State();
}

class _Screen_1State extends State<Screen_1> {

  List images = [
    "https://akm-img-a-in.tosshub.com/indiatoday/images/photogallery/201303/w-25powerful-women-mar-25_031313040617.jpg?VersionId=Jz7n1wE2dEOev9b5MWNK_JS0vFTtmgSG&size=686:*",
    "https://media.istockphoto.com/id/1185367863/photo/smiling-business-woman-portrait.jpg?s=612x612&w=0&k=20&c=i19PDtTroZB0r1K1MmWARhdfQ4NHoTYB7SDyDn8W09I=",
    "https://images.pexels.com/photos/1624229/pexels-photo-1624229.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://img.freepik.com/free-photo/handsome-bearded-guy-posing-against-white-wall_273609-20597.jpg?size=626&ext=jpg&ga=GA1.1.2082370165.1716508800&semt=sph",
    "https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg",
    "https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg",
    "https://img.freepik.com/free-photo/smiley-man-holding-camera-front-view_23-2149915895.jpg",
    "https://media.licdn.com/dms/image/D4E03AQFefpBz6Rpxhw/profile-displayphoto-shrink_800_800/0/1692823545111?e=2147483647&v=beta&t=L5aBS7DoEco1eaxtEdN0tSC2FRY23so5CaFCPJ7uyFQ",
    "https://media.istockphoto.com/id/1369508766/photo/beautiful-successful-latin-woman-smiling.jpg?s=612x612&w=0&k=20&c=LoznG6eGT42_rs9G1dOLumOTlAveLpuOi_U755l_fqI="
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/sc_3/credit_unpress.png",height: 100.h,),
              ),
              Padding(
                padding: const EdgeInsets.only(left:  42,top: 17),
                child: Text("3",style: TextStyle(fontSize: 18)),
              ),

            ],
          )
        ],
        foregroundColor: Colors.white,
        title: const Text('Old money',style: TextStyle(color: Colors.white,fontSize: 22)),
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.only(top: 30,bottom: 10,left: 10,right: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Screen_2(Image: images[index],)),
                );
              },
            ),
          );
        },
      ),

    );
  }
}
