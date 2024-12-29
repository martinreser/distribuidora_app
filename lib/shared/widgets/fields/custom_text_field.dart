import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isRequired;

  const CustomTextField(
      {super.key,
      required this.label,
      required this.hintText,
      required this.controller,
      this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
      ),
      validator: (value) {
        if (isRequired) {
          return value == '' ? 'El $label es requerido' : null;
        }
        return null;
      },
    );
  }
}
