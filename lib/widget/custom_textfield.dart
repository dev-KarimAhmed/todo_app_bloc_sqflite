import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      this.onTap,
      this.keyboardType,
     required  this.labelText,
      required this.icon
      });
  final TextEditingController controller;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final String labelText;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}

/**
 * //Icons.watch_later_outlined
 *  showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((time) {
                                if (time == null) {
                                  return '';
                                } else {
                                  controller.text =
                                      time.format(context).toString();
                                  print(time.format(context));
                                  print(controller.text);
                                }
                              });
 */