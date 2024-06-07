import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApiCallPage extends StatefulWidget {
  final String sourceImageUrl;
  final String? targetImageUrl;

  const MyApiCallPage({
    Key? key,
    required this.sourceImageUrl,
    required this.targetImageUrl,
  }) : super(key: key);

  @override
  _MyApiCallPageState createState() => _MyApiCallPageState();
}

class _MyApiCallPageState extends State<MyApiCallPage> {
  var responseData;
  String base64String = '';
  bool isLoading = false;

  Future<void> callAPI() async {
    String apiUrl = 'https://deepfake-face-swap.p.rapidapi.com/swap';
    Map<String, dynamic> requestBody = {
      'source': widget.sourceImageUrl,
      'target': widget.targetImageUrl!,
    };

    String requestBodyJson = json.encode(requestBody);
    showLoadingDialog();
    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-rapidapi-key':
              'c21cbf7047msh063c48a4e76a10cp1093bfjsnee0ba6b3cd5a',
          'x-rapidapi-host': 'deepfake-face-swap.p.rapidapi.com',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        setState(() {
          base64String = responseData["result"];
          isLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        isLoading = false;
      });
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
    }
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  void showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Loading'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? _bytesImage;
    if (base64String.isNotEmpty) {
      try {
        _bytesImage = Base64Decoder().convert(base64String);
      } catch (e) {
        print('Error decoding base64 string: $e');
      }
    }

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isLoading)
                CircularProgressIndicator()
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: _bytesImage != null
                      ? Image.memory(_bytesImage)
                      : Text("No Image", style: TextStyle(color: Colors.white)),
                ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 120),
                ),
                onPressed: () {},
                child: Text(
                  'Photo Added',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
