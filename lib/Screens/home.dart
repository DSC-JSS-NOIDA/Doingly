import 'dart:io';
import 'package:dsc_project/Service/HiveDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.image});
  final File? image;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String greet = "";
  String? name;
  File image = Get.arguments;

  String? images;
  ToDoDataBase db = ToDoDataBase();
  final _mybox = Hive.box('myBox');
  List checkedBox = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late String title;
  late String description;
  bool isDarkMode = false; // Initially set to false (light mode)

  DateTime createdTime = DateTime.now();

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "Anonymous";
    });

    return name!;
  }

  Future<String?> getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      images = prefs.getString('imagePath');
    });

    return images;
  }

  void Greet() {
    setState(() {
      if ((DateTime.now().hour) > 4 && ((DateTime.now().hour) <= 12)) {
        greet = "Good Morning,";
      } else if ((DateTime.now().hour) > 12 && (DateTime.now().hour) < 17) {
        greet = "Good Afternoon,";
      } else {
        greet = "Good Evening,";
      }
    });
  }

  void saveNewTask(String title, String description, DateTime createdTime) {
    setState(() {
      db.toDoList.add({
        "title": title,
        "description": description,
        "createdTime": createdTime
      });
    });

    _titleController.clear();
    _descriptionController.clear();
    db.updateDataBase();
    Navigator.pop(context);
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });

    db.updateDataBase();
  }

  void dialogueBox() {
    Get.defaultDialog(
        titlePadding: EdgeInsets.all(16),
        onCancel: () {},
        title: "Create",
        titleStyle: GoogleFonts.spaceGrotesk(color: Colors.black,fontWeight: FontWeight.bold),
        onConfirm: () {
          saveNewTask(
              _titleController.text, _descriptionController.text, createdTime);
          print(db.toDoList);
        },
        textConfirm: "Save",
        buttonColor: Colors.red[400],
        contentPadding: EdgeInsets.all(20),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Start typing..'),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    Greet();
    getImage();
    getName();
    print(greet);
  }

  double FontSize() {
    double availableWidth = 400.0; // Adjust this based on your available width

    double fontSize = 28; // Default font size
    if (name.toString().length * fontSize > availableWidth) {
      fontSize = availableWidth / name.toString().length;
    }
    return fontSize;
  }

//  FloatingActionButton(
//         onPressed: () {
//           dialogueBox();
//         },
//         elevation: 4,
//         backgroundColor: Colors.red[200],
//         child: const Icon(Icons.add),
//         enableFeedback: true,
//       ),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //      appBar: AppBar(), //AppBar is not used in this project

      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        buttonSize: Size(60, 60),
        animationDuration:Duration(milliseconds: 500),
        direction:SpeedDialDirection.left,
        childMargin: EdgeInsets.all(10),
        childrenButtonSize: Size(65, 65),
        childPadding: EdgeInsets.all(4),
        children: [
          SpeedDialChild(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)
            ),
            child: const Icon(Icons.add),
            backgroundColor: Colors.red[200],
            onTap: () {
              dialogueBox();
            },
          ),
         
          SpeedDialChild(
              onTap: () {
              // setState(() {
              //           isDarkMode = !isDarkMode;
              //         });
              },
              child: Transform.scale(
                scale: 0.8,
                child: GestureDetector(
                  onTap: (){
                    // setState(() {
                    //     isDarkMode = !isDarkMode;
                    //   });
                  },
                  child: Switch(
                      value: isDarkMode,
                      thumbIcon:
                          MaterialStateProperty.resolveWith<Icon?>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Icon(Icons.light_rounded);
                        } else {
                          return const Icon(Icons.dark_mode_rounded);
                        }
                      }),
                      activeColor: Colors.red[400],
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = !isDarkMode;
                        });
                      }),
                ),
              ))
        ],
      ),

      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        greet,
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 23,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit
                          .scaleDown, // Scale down the text to fit within the bounds
                      child: Text(
                        name.toString(),
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize(),
                          // Set a default font size
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Show ellipsis (...) for overflowing text
                        maxLines: 1, // Limit the text to one line
                      ),
                    )
                  ],
                ),
                widget.image != null
                    ? CircleAvatar(
                        radius: 35, backgroundImage: FileImage((widget.image!)))
                    : CircleAvatar(
                        radius: 35,
                        child: Image.asset('assets/images/name.png')),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Tasks (${db.toDoList.length})",
              style:
                  GoogleFonts.spaceGrotesk(fontSize: 25, color: Colors.black),
            ),
            Container(
                width: 100,
                child: const Divider(
                  color: Colors.black87,
                )),
            Expanded(
                child: ListView.builder(
                    itemCount: db.toDoList.length,
                    itemBuilder: (context, index) {
                      String? title = db.toDoList[index]["title"];
                      String? description = db.toDoList[index]["description"];
                      DateTime? createdAt = db.toDoList[index]["createdTime"];
                      return Slidable(
                        direction: Axis.horizontal,
                        endActionPane: ActionPane(
                            extentRatio: 0.6,
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: ((context) => {deleteTask(index)}),
                                backgroundColor: Colors.red,
                                icon: Icons.delete_rounded,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              SizedBox(width: 5),
                              SlidableAction(
                                onPressed: (value) {},
                                backgroundColor: Colors.blue,
                                icon: Icons.edit,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ]),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (checkedBox.contains(index)) {
                                checkedBox.remove(index);
                              } else {
                                checkedBox.add(index);
                              }
                            });
                            print(checkedBox);
                          },
                          child: Card(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            color: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            shadowColor: Colors.red[300],
                            child: ListTile(
                              leading: checkedBox.contains(index)
                                  ? Icon(Icons.check_box_rounded)
                                  : Icon(Icons.check_box_outline_blank_rounded),
                              title: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  title.toString(),
                                  style: GoogleFonts.spaceGrotesk(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  description.toString(),
                                  style: GoogleFonts.spaceGrotesk(fontSize: 15),
                                ),
                                // Text(index.toString()),
                              ),
                              trailing: SizedBox(
                                width: 60,
                                child: Text(
                                  createdAt.toString(),
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      )),
    );
  }
}
