import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/list.dart';
import '../views/archived_tasks.dart';
import '../views/done_tasks.dart';
import '../views/new_tasks.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [NewTasks(), DoneTasks(), ArchivedTasks()];
  List<String> titles = ['Tasks', 'Done Tasks', 'Archived Tasks'];
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomSheet());
  }

  void createDB() {
    openDatabase(
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
        getDataFromDB(database);
      },
    ).then((value) {
      database = value;
      emit(CreateDB());
    });
  }

  insertToDB({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('Data Inserted successfuly');
        emit(InsertDB());
        getDataFromDB(database);
      }).catchError((error) {
        print('error while inserting...${error.toString()}');
      });
      return '';
    });
  }

  void getDataFromDB(Database database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(GetDB());
    });
  }

  bool isShowBottomSheet = false;
  IconData icon = Icons.edit;
  void changeIcon({required bool showBottomSheet, required IconData myIcon}) {
    isShowBottomSheet = showBottomSheet;
    icon = myIcon;
    emit(AppChangeClick());
  }

  void updateDB({required String status, required int id}) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDB(database);
      emit(UpdateDB());
    });
  }
}
