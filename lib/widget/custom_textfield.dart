import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      this.onTap,
      this.keyboardType,
      required this.labelText,
      required this.icon, this.readOnly});
  final TextEditingController controller;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final String labelText;
  final IconData icon;
  final bool? readOnly;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      readOnly: readOnly??true,
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
