import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_bloc_sqflite/views/archived_tasks.dart';
import 'package:todo_app_bloc_sqflite/views/done_tasks.dart';
import 'package:todo_app_bloc_sqflite/views/new_tasks.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite_lib;

import '../services/db.dart';

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

  @override
  void initState() {
    super.initState();
    DatabaseService().createDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      floatingActionButton: Form(
        key: formKey,
        child: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                if (isShowBottomSheet) {
                  Navigator.pop(context);
                  setState(() {
                    isShowBottomSheet = false;
                  });
                } else {
                  Scaffold.of(context)
                      .showBottomSheet<void>((BuildContext context) {
                    return Container(
                      color: Colors.grey[300],
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Task Title',
                              prefixIcon: Icon(Icons.title),
                              border: OutlineInputBorder(),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: timeController,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((time) {
                                if (time == null) {
                                  return '';
                                } else {
                                  timeController.text =
                                      time.format(context).toString();
                                  print(time.format(context));
                                  print(timeController.text);
                                }
                              });
                            },
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: 'Task Time',
                              prefixIcon: Icon(Icons.watch_later_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: dateController,
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime.parse('2030-12-31'))
                                  .then((date) {
                                if (date == null) {
                                  return '';
                                } else {
                                  dateController.text =
                                      date.toString();
                                  print(date);
                                  print(dateController.text);
                                }
                              });
                            },
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: 'Task Time',
                              prefixIcon: Icon(Icons.watch_later_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    );
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
      ),
      body: screens[currentIndex],
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

 }
