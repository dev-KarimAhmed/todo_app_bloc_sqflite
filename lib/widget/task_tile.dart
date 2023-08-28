import 'package:flutter/material.dart';
import 'package:todo_app_bloc_sqflite/cubit/app_cubit.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.data,
  });
  final Map data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            child: Text('${data['time']}'),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data['title']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  '${data['date']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                AppCubit.get(context).updateDB(status: 'done', id: data['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {
                AppCubit.get(context).updateDB(status: 'arcived', id: data['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.grey,
              )),
        ],
      ),
    );
  }
}
