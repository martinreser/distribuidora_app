import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordField extends HookWidget {
  final TextEditingController controller;
  final ExpansionTileController? expansionController;
  final String? errorText;
  final bool isRegister;

  const PasswordField(
      {super.key,
      required this.controller,
      required this.expansionController,
      this.errorText,
      this.isRegister = false});

  bool hasMinLength(String password) => password.length >= 8;
  bool hasUppercase(String password) => password.contains(RegExp(r'[A-Z]'));
  bool hasLowercase(String password) => password.contains(RegExp(r'[a-z]'));
  bool hasNumber(String password) => password.contains(RegExp(r'[0-9]'));

  String? validatePassword(String? password) {
    if ((!hasMinLength(password ?? '') ||
            !hasUppercase(password ?? '') ||
            !hasLowercase(password ?? '') ||
            !hasNumber(password ?? '')) ||
        password == '') {
      return 'Ingresa una contraseña valida';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final show = useState<bool>(true);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        TextFormField(
          controller: controller,
          onChanged: (value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (value != '' && isRegister && expansionController != null) {
                if (!hasMinLength(value) ||
                    !hasUppercase(value) ||
                    !hasLowercase(value) ||
                    !hasNumber(value)) {
                  expansionController?.expand();
                } else {
                  expansionController?.collapse();
                }
              }
            });
          },
          decoration: InputDecoration(
            labelText: "Contraseña",
            hintText: "●●●●●●●●",
            errorText: errorText,
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: GestureDetector(
              onLongPress: () {
                show.value = false;
              },
              onLongPressEnd: (_) {
                show.value = true;
              },
              child: Icon(
                show.value ? Icons.visibility_off : Icons.visibility,
                color: controller.text != '' ? colorScheme.primary : null,
              ),
            ),
          ),
          obscureText: show.value,
          validator: isRegister ? validatePassword : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        if (controller.text != '' && isRegister)
          ExpansionTile(
            controller: expansionController,
            expandedAlignment: Alignment.topLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title:
                const Text('Debe cumplir con los siguientes requerimientos:'),
            tilePadding: EdgeInsets.zero,
            leading: validatePassword(controller.text) != null
                ? Icon(Icons.close, color: colorScheme.error)
                : Icon(Icons.check, color: colorScheme.onError),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  '* 8 o más caracteres',
                  style: TextStyle(
                    color: hasMinLength(controller.text)
                        ? colorScheme.onError
                        : colorScheme.error,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  '* Al menos una letra mayúscula',
                  style: TextStyle(
                    color: hasUppercase(controller.text)
                        ? colorScheme.onError
                        : colorScheme.error,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  '* Al menos una letra minúscula',
                  style: TextStyle(
                    color: hasLowercase(controller.text)
                        ? colorScheme.onError
                        : colorScheme.error,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  '* Al menos un número',
                  style: TextStyle(
                    color: hasNumber(controller.text)
                        ? colorScheme.onError
                        : colorScheme.error,
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }
}
