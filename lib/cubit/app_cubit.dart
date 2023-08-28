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
  List<Map> tasks = [];

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
        getDataFromDB(database).then((value) {
          tasks = value;
          print(tasks);
          emit(GetDB());
        });
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
        getDataFromDB(database).then((value) {
          tasks = value;
          print(tasks);
          emit(GetDB());
        });

      }).catchError((error) {
        print('error while inserting...${error.toString()}');
      });
      return '';
    });
  }

  Future<List<Map>> getDataFromDB(Database database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }

  bool isShowBottomSheet = false;
  IconData icon = Icons.edit;
  void changeIcon({required bool showBottomSheet, required IconData myIcon}) {
    isShowBottomSheet = showBottomSheet;
    icon = myIcon;
    emit(AppChangeClick());
  }
}
