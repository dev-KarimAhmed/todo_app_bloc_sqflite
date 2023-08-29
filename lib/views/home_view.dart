
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


import '../cubit/app_cubit.dart';
import '../cubit/cubit/change_theme_cubit.dart';
import '../widget/custom_textfield.dart';

/*
1. create DB
2. Create tables
3. open DB
4. insert to DB
5. get from DB
6. update DB
7. delete from DB 
*/
class HomePage extends StatelessWidget {
 final TextEditingController titleController = TextEditingController();
 final TextEditingController timeController = TextEditingController();
 final TextEditingController dateController = TextEditingController();
 final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is InsertDB) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppCubit.get(context)
                .titles[AppCubit.get(context).currentIndex]),
            actions: [
              
                
                   IconButton(
                      onPressed: () {
                        ChangeThemeCubit.get(context).changeTheme();
                      },
                      icon: ChangeThemeCubit.get(context).iconTheme),
                
              
            ],
          ),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  print(formKey.currentState?.validate());
                  if (AppCubit.get(context).isShowBottomSheet) {
                    // print('${formKey.currentState?.validate()} 1');
                    if (formKey.currentState?.validate() == null) {
                      // print('${formKey.currentState?.validate()} 2');
                      // // AppCubit.get(context).insertToDB(
                      // //     title: titleController.text,
                      // //     time: timeController.text,
                      // //     date: dateController.text);
                      // //       titleController.clear();
                      // // timeController.clear();
                      // // dateController.clear();
                    } else if (formKey.currentState?.validate() == true) {
                      // print('${formKey.currentState?.validate()} 3');
                      AppCubit.get(context).insertToDB(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
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
                                    readOnly: false,
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

                          AppCubit.get(context).changeIcon(
                              showBottomSheet: false, myIcon: Icons.edit);
                        });
                    AppCubit.get(context)
                        .changeIcon(showBottomSheet: true, myIcon: Icons.add);
                  }
                },
                child: Icon(AppCubit.get(context).icon),
              );
            },
          ),
          body:
              AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
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
      },
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
}
