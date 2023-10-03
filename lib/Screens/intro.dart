import 'package:dsc_project/Screens/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Doingly",
                  style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Color(0xffFF4655)),
                ),
              ),
              // SizedBox(height: 60,),
              Expanded(flex: 5, child: Image.asset("assets/images/intro.png")),
              // SizedBox(height: 20,),
              Text("Welcome to Doingly!",
                  style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black)),
              Container(width: 180, child: Divider()),
              Expanded(
                flex: 2,
                child: Text(
                    "Start managing your task on time.\nMore Faster with us.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey)),
              ),
              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF4655)),
                  onPressed: () {
                    Get.to(() => NameScreen());
                  },
                  child: Text("Next",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white)),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
