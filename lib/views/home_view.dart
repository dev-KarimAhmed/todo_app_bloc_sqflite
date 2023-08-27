import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_bloc_sqflite/views/archived_tasks.dart';
import 'package:todo_app_bloc_sqflite/views/done_tasks.dart';
import 'package:todo_app_bloc_sqflite/views/new_tasks.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite_lib;

import '../constants/list.dart';
import '../widget/custom_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/*
1. create DB
2. Create tables
3. open DB
4. insert to DB
5. get from DB
6. update DB
7. delete from DB 
*/
class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Widget> screens = [NewTasks(), DoneTasks(), ArchivedTasks()];
  List<String> titles = ['Tasks', 'Done Tasks', 'Archived Tasks'];
  bool isShowBottomSheet = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Database database;

  @override
  void initState() {
    super.initState();
    createDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              print(formKey.currentState?.validate());
              if (isShowBottomSheet) {
                print('${formKey.currentState?.validate()} 1');
                if (formKey.currentState?.validate() == null) {
                  print('${formKey.currentState?.validate()} 2');
                  insertToDB(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text,
                  ).then((value) {
                    getDataFromDB(database).then((value) {
                      Navigator.pop(context);
                      setState(() {
                        tasks = value;
                        isShowBottomSheet = false;
                        print(tasks);
                      });
                      titleController.clear();
                      timeController.clear();
                      dateController.clear();
                    });
                  });
                } else if (formKey.currentState?.validate() == true) {
                  print('${formKey.currentState?.validate()} 3');
                  insertToDB(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text,
                  ).then((value) {
                    getDataFromDB(database).then((value) {
                      Navigator.pop(context);
                      setState(() {
                        tasks = value;
                        isShowBottomSheet = false;
                        print(tasks.last);
                      });
                    });
                  });
                  titleController.clear();
                  timeController.clear();
                  dateController.clear();
                }
              } else {
                print('${formKey.currentState?.validate()} 4');
                Scaffold.of(context)
                    .showBottomSheet<void>(elevation: 20,
                        (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextField(
                                controller: titleController,
                                labelText: 'Task Title',
                                icon: Icons.title,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                controller: timeController,
                                labelText: 'Task Time',
                                icon: Icons.watch_later_outlined,
                                onTap: () {
                                  timePicker(context);
                                },
                                keyboardType: TextInputType.datetime,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                controller: dateController,
                                labelText: 'Task Date',
                                icon: Icons.calendar_today,
                                keyboardType: TextInputType.datetime,
                                onTap: () {
                                  datePicker(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                    .closed
                    .then((value) {
                      print(formKey.currentState?.validate());

                      setState(() {
                        isShowBottomSheet = false;
                      });
                    });
                setState(() {
                  isShowBottomSheet = true;
                });
              }
            },
            child: Icon(isShowBottomSheet ? Icons.add : Icons.edit),
          );
        },
      ),
      body: tasks.length == 0
          ? Center(child: CircularProgressIndicator())
          : screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive), label: 'Archived'),
          ]),
    );
  }

  Future<String?> datePicker(BuildContext context) {
    return showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: DateTime.now(),
            lastDate: DateTime.parse('2030-12-31'))
        .then((date) {
      if (date == null) {
        return '';
      } else {
        dateController.text = DateFormat().add_yMMMd().format(date);
        print(DateFormat().add_yMMMd().format(date));
        print(dateController.text);
      }
      return null;
    });
  }

  Future<String?> timePicker(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      if (time == null) {
        return '';
      } else {
        timeController.text = time.format(context).toString();
        print(time.format(context));
        print(timeController.text);
      }
    });
  }

  void createDB() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database database, int version) async {
        print('database created');
        //id integer but aut generated
        //title String
        //date String
        //time String
        //status String
        await database.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT ,date TEXT,time TEXT,status TEXT)');
      },
      onOpen: (database) {
        print('database Opened');
        getDataFromDB(database).then((value) {
          tasks = value;
          setState(() {});
        });
      },
    );
  }

  Future insertToDB({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('Data Inserted successfuly');
      }).catchError((error) {
        print('error while inserting...${error.toString()}');
      });
      return '';
    });
  }

  Future<List<Map>> getDataFromDB(Database database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}
