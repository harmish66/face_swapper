import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'api_call.dart';

class Screen_2 extends StatefulWidget {
  final String Image;

  const Screen_2({super.key, required this.Image});

  @override
  State<Screen_2> createState() => _Screen_2State();
}

class _Screen_2State extends State<Screen_2> {
  XFile? _imageFile;
  String? _targetImageUrl;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(pickedFile);
    }
  }

  Future<void> _clickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _cropImage(pickedFile);
    }
  }

  Future<void> _cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _imageFile = XFile(croppedFile.path);
        uploadImageTarget(_imageFile!);
      });
    }
  }

  Future<void> uploadImageTarget(XFile imageFile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Uploading image..."),
            ],
          ),
        );
      },
    );

    var url = Uri.parse('https://tmpfiles.org/api/v1/upload');
    var request2 = http.MultipartRequest('POST', url);
    request2.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));
    try {
      var response2 = await request2.send();
      Navigator.of(context).pop();
      if (response2.statusCode == 200) {
        var responseData2 = await response2.stream.toBytes();
        var result2 = String.fromCharCodes(responseData2);
        var jsonResult2 = json.decode(result2);
        String imageUrl2 = jsonResult2['data']['url'];
        List<String> parts2 = imageUrl2.split('/');
        String splited2 =
            '${parts2.sublist(0, 3).join('/')}/dl/${parts2.sublist(3).join('/')}';
        setState(() {
          _targetImageUrl = splited2;
          print(_targetImageUrl);
        });
      } else {
        print('Failed to upload image 2. Status code: ${response2.statusCode}');
      }
    } catch (e) {
      print('Error uploading image 2: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Header image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      widget.Image, // Replace with your image path
                      width: 240,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Make sure it's a front-facing photo with clear features",
                    style: TextStyle(fontSize: 35.sp, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Import photo section
                  Container(
                    width: 100,
                    height: 100,
                    /*decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),*/
                    child: _imageFile == null
                        ? Image.asset(
                            "assets/sc_8/import_your_photo_unpress.png",
                            height: 100,
                            width: 100,
                          )
                        : Image.file(
                            File(_imageFile!.path),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(height: 15),
                  // Buttons
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 37),
                        ),
                        onPressed: () {
                          _clickImage();
                        },
                        child: Text(
                          'Taking selfies',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 37),
                        ),
                        onPressed: () {
                          _pickImage();
                        },
                        child: Text(
                          'Your Photos',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 120),
                    ),
                    onPressed: () {
                      setState(() {
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyApiCallPage(
                                sourceImageUrl: widget.Image,
                                targetImageUrl: _targetImageUrl!,
                              )));
                      print(_targetImageUrl);
                      print(widget.Image);
                    },
                    child: Text(
                      'Generate',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
