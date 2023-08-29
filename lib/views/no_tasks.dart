import 'package:flutter/material.dart';

class NoTasksScreen extends StatelessWidget {
  const NoTasksScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_rounded,
              size: 56,
              color: ThemeData == ThemeData.dark()?  Colors.white: Colors.grey,
            ),
            Text(
              'No Tasks yet, Please Add Some Tasks...',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
  }
}
