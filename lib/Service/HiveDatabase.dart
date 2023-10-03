import 'package:hive/hive.dart';

class ToDoDataBase {
 List<dynamic> toDoList = [];
  //reference our box
  final _myBox = Hive.box('mybox');
  //first time ever methid if u open this

  void createInitialData() {
    toDoList = [

    ];
  }

  //load thee data from data base

  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
