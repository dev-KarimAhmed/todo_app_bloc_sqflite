import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc_sqflite/constants/list.dart';
import 'package:todo_app_bloc_sqflite/cubit/app_cubit.dart';

import '../widget/task_tile.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      BlocConsumer<AppCubit,AppState>(
        listener: (context,state){},
        builder: (context,state){
          var tasks = AppCubit.get(context).tasks;
          return ListView.separated(
            itemBuilder: (context, index) => TaskTile(data: tasks[index]),
            separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
            itemCount: tasks.length
            );
        },
        
      );
    }
  }
