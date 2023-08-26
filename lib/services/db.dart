import 'package:sqflite/sqflite.dart';

class DatabaseService{
   late Database database;
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
      },
    );
  }

  void insertToDB() {
    database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("first task","2023","2:06","new")')
          .then((value) {
        print('Data Inserted successfuly');
      }).catchError((error) {
        print('error while inserting...${error.toString()}');
      });
      return '';
    });
  }


}