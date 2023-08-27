import 'package:flutter/material.dart';

import 'custom_textfield.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet(
      {super.key,
      required this.titleController,
      required this.timeController,
      required this.dateController});
  final TextEditingController titleController;
  final TextEditingController timeController;
  final TextEditingController dateController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: titleController,
              labelText: 'Task Title',
              icon: Icons.title,
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
        dateController.text = date.toString();
        print(date);
        print(dateController.text);
      }
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
