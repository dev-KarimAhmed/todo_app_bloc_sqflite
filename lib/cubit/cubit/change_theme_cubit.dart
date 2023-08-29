import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_theme_state.dart';

class ChangeThemeCubit extends Cubit<ChangeThemeState> {
  ChangeThemeCubit() : super(ChangeThemeInitial());
  static ChangeThemeCubit get(context) => BlocProvider.of(context);
  bool isDarkMode = false;
  Icon iconTheme = Icon(Icons.dark_mode);
  void changeTheme() {
    if (isDarkMode) {
      iconTheme = Icon(Icons.dark_mode);
      isDarkMode = false;
      print(isDarkMode);

      emit(ThemeChangedToDark());
    } else {
      isDarkMode = true;
      iconTheme = Icon(Icons.light_mode);
      print(isDarkMode);
      emit(ThemeChangedToLight());
    }
  }
}
