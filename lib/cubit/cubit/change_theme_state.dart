part of 'change_theme_cubit.dart';

@immutable
abstract class ChangeThemeState {}

 class ChangeThemeInitial extends ChangeThemeState {}
 class ThemeChangedToDark extends ChangeThemeState {}
class ThemeChangedToLight extends ChangeThemeState {}
