import 'dart:io';

import 'package:dsc_project/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController _controller = TextEditingController();
  String name = '';
  File? _selectedImage = null;
  Future<void> setName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);

    print("done");
  }

  Future<void> setImage(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imagePath', path);

    print("done");
  }

  Future<void> pickAndDisplayImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("No image selected");
    }
  }

  Future<void> _pickImage() async {
    await Get.defaultDialog(
      title: "Select Image",
      titleStyle: GoogleFonts.spaceGrotesk(fontSize: 20, color: Colors.red),
      backgroundColor: Colors.white,
      content: Column(
        children: [
          TextButton(
            onPressed: () {
              pickAndDisplayImage();
              Navigator.pop(context);
            },
            child: Text(
              "Pick from Gallery",
              style:
                  GoogleFonts.spaceGrotesk(fontSize: 15, color: Colors.black),
            ),
          ),
          Container(width: 100, child: Divider()),
          TextButton(
            onPressed: () {
              captureAndDisplayImage();
              Navigator.pop(context);
            },
            child: Text(
              "Use Camera",
              style:
                  GoogleFonts.spaceGrotesk(fontSize: 15, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> captureAndDisplayImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("No image selected");
    }
  }

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
              Expanded(
                flex: 1,
                child: _selectedImage != null
                    ? GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: FileImage(_selectedImage!),
                        ),
                      )
                    : GestureDetector(
                      onTap: () {
                          _pickImage();
                        },
                      child: CircleAvatar(
                          backgroundColor: Colors.red[100],
                          radius: 100,
                          child: Image.asset(
                            "assets/images/name2.png",
                          ),
                        ),
                    ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  onChanged: (value) {
                    name = value;
                  },
                  controller: _controller,
                  style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color(0xffFF4655),
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        )),
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold),
                    labelText: "Write your name.",
                    fillColor: Color(0xff4655),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF4655)),
                  onPressed: () {
                    if (name == "") {
                      Get.snackbar("Going without typing name?",
                          "Please tell us your respected name.");
                    } else {
                      setName(name);
                     
                      Get.off(() => HomeScreen(), arguments: _selectedImage);
                    }
                  },
                  child: Text("Get Started",
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
