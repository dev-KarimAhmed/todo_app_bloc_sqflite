import 'package:flutter/material.dart';
import 'package:todo_app_bloc_sqflite/views/home_view.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      home:  HomePage(),
    );
  }
}

