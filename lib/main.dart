import 'package:dsc_project/Screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Hive.initFlutter();

  try {
    var box = await Hive.openBox('mybox'); 
  } catch (e) {
    print('Error opening Hive box: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);  // Corrected key forwarding syntax

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Doingly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: IntroScreen(),
    );
  }
}
