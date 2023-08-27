import 'package:flutter/material.dart';
import 'package:todo_app_bloc_sqflite/constants/list.dart';

import '../widget/task_tile.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => TaskTile(data: tasks[index]),
        separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
        itemCount: tasks.length
        );
  }
}
