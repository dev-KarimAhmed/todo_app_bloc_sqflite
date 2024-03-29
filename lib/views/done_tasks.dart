
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../widget/task_tile.dart';
import 'no_tasks.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<AppCubit,AppState>(
        listener: (context,state){},
        builder: (context,state){
          var tasks = AppCubit.get(context).doneTasks;
          return tasks.length==0 ? NoTasksScreen(): ListView.separated(
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