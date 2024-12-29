import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isEmailValid = emailRegex.hasMatch(email ?? '') || email == '';
    if (!isEmailValid) {
      return 'Ingresa un email valido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "example@email.com",
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.email_outlined,
          color: Colors.grey,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
