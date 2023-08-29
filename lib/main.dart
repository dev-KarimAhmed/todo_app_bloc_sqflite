import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc_sqflite/views/home_view.dart';

import 'cubit/app_cubit.dart';
import 'cubit/bloc_observer.dart';
import 'cubit/cubit/change_theme_cubit.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AppCubit()..createDB(),
      ),
      BlocProvider(
        create: (context) => ChangeThemeCubit(),
      ),
    ],
    child: ToDoApp(),
  ));
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeThemeCubit, ChangeThemeState>(
      builder: (context, state) {
        return MaterialApp(
          theme: ChangeThemeCubit.get(context).isDarkMode
              ? ThemeData.dark()
              : ThemeData.light(),
          debugShowCheckedModeBanner: false,
          title: 'Todo',
          home: HomePage(),
        );
      },
    );
  }
}
