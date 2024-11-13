import 'dart:io';
import 'dart:convert'; // To handle JSON data if necessary
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:ph_checker/home_page.dart';
import 'package:ph_checker/result_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart'; // For content type handling


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraPage> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;


  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      print('Error capturing image: $e');
    }
  }
  //padding: const EdgeInsets.all(8.0),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(26, 34, 46, 1),
          leadingWidth: 200,
          leading: Row(
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child:  TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back_ios,color: Colors.black,size: 10.0,),
                      Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )
                ),
              )
            ],
          ),
        ),
        body: Stack(
        children: [
          Positioned.fill(
            child: _initializeControllerFuture == null
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(8.0),
                      color: const Color.fromRGBO(26, 34, 46, 1),
                      child: ClipRRect(


                        borderRadius: BorderRadius.circular(8.0),
                        child: CameraPreview(_controller),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _captureImage,
                child: const Icon(
                  Icons.camera,
                  size: 70,
                  color: Colors.black,
                ),
              )

            ),
          ),
        ],
      ),
    );
  }
}


class PreviewScreen extends StatefulWidget {
  final String imagePath;

  const PreviewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool isLoading = false; // Add a flag to track loading state

  // Example of a function to handle the "Proceed" action
  Future<void> proceedFunction(BuildContext context) async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      var file = File(widget.imagePath);
      var uri = Uri.parse('https://50d1-196-10-215-1.ngrok-free.app/upload/image'); // Replace with your actual endpoint
      var request = http.MultipartRequest('POST', uri);
      var multipartFile = await http.MultipartFile.fromPath('image', file.path,
          contentType: MediaType('image', 'jpeg')); // Assuming it's a jpeg image, adjust as necessary
      request.files.add(multipartFile);
      var response = await request.send();

      if (response.statusCode == 200) {
        // Handle successful response
        var responseBody = await response.stream.bytesToString();
        var phValue = jsonDecode(responseBody)['ph'] ?? 'N/A'; // Example, assuming the response contains a 'ph' key
        double? roundedPhValue = double.tryParse(phValue.toString());
        String phValueRounded = roundedPhValue != null ? roundedPhValue.toStringAsFixed(3) : 'N/A';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(ph: phValueRounded),
          ),
        );
      } else {
        // Handle failed response
        Fluttertoast.showToast(
          msg: "Failed to retrieve pH value",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      // Handle error (e.g., network failure)
      Fluttertoast.showToast(
        msg: "Failed to retrieve pH value",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    setState(() {
      isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(26, 34, 46, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CameraPage()),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Image.file(
              File(widget.imagePath), // Use widget.imagePath to access the property
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isLoading ? null : () => proceedFunction(context), // Disable the button while loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(26, 34, 46, 1),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: isLoading // Check if loading is true to show the loading indicator
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text(
                'Proceed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





//
// void proceedFunction(BuildContext context) {
//   // Add your action logic here, e.g., navigate to another page
//   showToast(message: "Failed to retrieve pH value");
//   // Example navigation or other function
//   // Navigator.push(
//   //   context,
//   //   MaterialPageRoute(builder: (context) => const ResultPage()),
//   // );
// }