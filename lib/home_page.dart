import 'package:flutter/material.dart';
import 'package:ph_checker/image_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/home_background_image.png"), fit: BoxFit.cover )
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CameraPage()));

          },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(26, 34, 46, 1),
              minimumSize: const Size(200, 70)
            ), child: const Text("Scan Image", style: TextStyle(color: Colors.white, fontSize: 20),),


          ),

        ],
      ),
      ),

    );
  }
}
