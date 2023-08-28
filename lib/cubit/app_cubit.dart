import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomSheet());
  }
}
