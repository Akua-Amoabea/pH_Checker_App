import 'package:flutter/material.dart';
import 'package:ph_checker/image_page.dart';

class ResultPage extends StatelessWidget {
  final String ph;

  const ResultPage({Key? key, required this.ph}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(67, 126, 175, 1),
      body: Center(
        child: SizedBox(
          height: 350,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 300,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(26, 34, 46, 1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Your pH value is',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),

              Container(
                height: 150,
                width: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$ph',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 79,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40,),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const CameraPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Scan a new image',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
void phValue(){

}
