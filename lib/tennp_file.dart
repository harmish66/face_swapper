// /*
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:ai_headshots/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'API/api_call.dart';
// import 'onboarding_screen.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(1080, 1920),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       // Use builder only if you need to use library outside ScreenUtilInit context
//       builder: (_, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'First Method',
//           // You can use the library anywhere in the app even in theme
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//             textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
//           ),
//           home: child,
//         );
//       },
//       child: SplashScreen(),
//     );
//   }
// }
//
// class ImageUploadPage extends StatefulWidget {
//   final String Image;
//
//   const ImageUploadPage({Key? key,required this.Image, }) : super(key: key);
//
//   @override
//   ImageUploadPageState createState() => ImageUploadPageState();
// }
//
// class ImageUploadPageState extends State<ImageUploadPage> {
//   File? sourceImage;
//   File? sourceImageCrop;
//   File? targetImage;
//   File? targetImageCrop;
//   final picker = ImagePicker();
//   String? _sourceImageUrl;
//   String? _targetImageUrl;
//
//   Future _pickSourceImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       sourceImage = File(pickedFile.path);
//       // _uploadImage(File(pickedFile.path), 'source');
//       _cropImageSource(sourceImage!.path);
//     } else {
//       print('No source image selected.');
//     }
//   }
//   Future<void> _pickTargetImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       targetImage = File(pickedFile.path);
//       _cropImageTarget(targetImage!.path);
//       // _uploadImage(File(targetImageCrop!.path), 'target');
//     } else {
//       print('No target image selected.');
//     }
//   }
//   Future<void> _cropImageSource(String imagePath) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: sourceImage!.path,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9
//       ],
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.deepOrange,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         IOSUiSettings(
//           title: 'Cropper',
//         ),
//         WebUiSettings(
//           context: context,
//         ),
//       ],
//     );
//     if (croppedFile != null) {
//       setState(() {
//         sourceImageCrop = File(croppedFile.path!);
//         uploadImageSource(File(sourceImageCrop!.path));
//       });
//     }
//   }
//   Future<void> _cropImageTarget(String imagePath) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: targetImage!.path,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9
//       ],
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.deepOrange,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         IOSUiSettings(
//           title: 'Cropper',
//         ),
//         WebUiSettings(
//           context: context,
//         ),
//       ],
//     );
//     if (croppedFile != null) {
//       setState(() {
//         targetImageCrop = File(croppedFile.path!);
//         uploadImageTarget(File(targetImageCrop!.path));
//       });
//     }
//   }
//   Future<void> uploadImageTarget(File imageFile) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text("Uploading image..."),
//             ],
//           ),
//         );
//       },
//     );
//
//     var url = Uri.parse('https://tmpfiles.org/api/v1/upload');
//     var request2 = http.MultipartRequest('POST', url);
//     request2.files
//         .add(await http.MultipartFile.fromPath('file', imageFile.path));
//     try {
//       var response2 = await request2.send();
//       Navigator.of(context).pop();
//       if (response2.statusCode == 200) {
//         var responseData2 = await response2.stream.toBytes();
//         var result2 = String.fromCharCodes(responseData2);
//         var jsonResult2 = json.decode(result2);
//         String imageUrl2 = jsonResult2['data']['url'];
//         List<String> parts2 = imageUrl2.split('/');
//         String splited2 = '${parts2.sublist(0, 3).join('/')}/dl/${parts2.sublist(3).join('/')}';
//         setState(() {
//           _targetImageUrl = splited2;
//         });
//       } else {
//         print('Failed to upload image 2. Status code: ${response2.statusCode}');
//       }
//     } catch (e) {
//       print('Error uploading image 2: $e');
//     }
//   }
//
//   Future<void> uploadImageSource(File imageFile) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text("Uploading image..."),
//             ],
//           ),
//         );
//       },
//     );
//     var url = Uri.parse('https://tmpfiles.org/api/v1/upload');
//     var request2 = http.MultipartRequest('POST', url);
//     request2.files
//         .add(await http.MultipartFile.fromPath('file', imageFile.path));
//     try {
//       var response2 = await request2.send();
//       Navigator.of(context).pop();
//       if (response2.statusCode == 200) {
//         var responseData2 = await response2.stream.toBytes();
//         var result2 = String.fromCharCodes(responseData2);
//         var jsonResult2 = json.decode(result2);
//         String imageUrl2 = jsonResult2['data']['url'];
//         List<String> parts2 = imageUrl2.split('/');
//         String splited2 = '${parts2.sublist(0, 3).join('/')}/dl/${parts2.sublist(3).join('/')}';
//         setState(() {
//           _sourceImageUrl = splited2;
//         });
//       } else {
//         print('Failed to upload image 2. Status code: ${response2.statusCode}');
//       }
//     } catch (e) {
//       print('Error uploading image 2: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Picker and Upload'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: _pickSourceImage,
//                 child: const Text('Pick Source Image'),
//               ),
//               sourceImage != null
//                   ? Image.file(sourceImageCrop!)
//                   : const Text("Not Selected Image"),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _pickTargetImage,
//                 child: const Text('Pick Target Image'),
//               ),
//               targetImage != null
//                   ? Image.file(targetImageCrop!)
//                   : const Text("Not Selected Image"),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                   onPressed: () {
//                     setState(() {});
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => MyApiCallPage(
//                           sourceImageUrl: _sourceImageUrl!,
//                           targetImageUrl: _targetImageUrl!,
//                         )));
//                   },
//                   child: const Text("SwapImage"))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// */
