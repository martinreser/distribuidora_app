import 'package:distribuidora_app/auth/auth_error.dart';
import 'package:distribuidora_app/presentation/models/user.dart';
import 'package:distribuidora_app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:distribuidora_app/shared/widgets/snackbar/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/utils/responsive.dart';
import '../shared/widgets/fields/fields.dart';
import 'auth_service.dart';

final _formRegisterKey = GlobalKey<FormState>();

class RegisterScreen extends HookWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final colorScheme = Theme.of(context).colorScheme;

    final expansionTileController = useExpansionTileController();
    final nameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final password = useState<String>("");

    String formatString(String input) {
      final trimmedInput = input.trim().replaceAll(RegExp(r'\s+'), ' ');
      if (trimmedInput.isEmpty) return '';
      return trimmedInput[0].toUpperCase() +
          trimmedInput.substring(1).toLowerCase();
    }

    goToSignIn(BuildContext context) {
      context.replace('/login');
    }

    goToHome(BuildContext context, UserModel user) {
      context.replace('/', extra: {'user': user});
    }

    signup() async {
      final result = await auth.createUser(
          formatString(nameController.text),
          formatString(lastNameController.text),
          emailController.text,
          passwordController.text);
      if (context.mounted) {
        if (result is AsyncData && result.hasValue) {
          CustomSnackBar.show(
            context: context,
            message: 'La cuenta fue creada correctamente',
            type: SnackBarType.success,
          );
          goToHome(context, result.value!);
        } else {
          if (result is AsyncError) {
            final error = result.error as AuthError;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(error.title),
                  content: Text(error.message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cerrar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        goToSignIn(context);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Iniciar sesion'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    }

    useEffect(() {
      passwordController.addListener(() {
        password.value = passwordController.text;
      });
      return null;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Form(
              key: _formRegisterKey,
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                              width: 300,
                            ),
                          ),
                          Text(
                            "Conoce los productos y ¡muchas cosas mas!",
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            "Registrate",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Wrap(spacing: 20, runSpacing: 20, children: [
                            if (!Responsive.isMobile(context))
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        label: 'Nombre',
                                        hintText: 'John',
                                        controller: nameController,
                                        isRequired: true,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: CustomTextField(
                                        label: 'Apellido',
                                        hintText: 'Doe',
                                        controller: lastNameController,
                                        isRequired: true,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Wrap(
                                runSpacing: 20,
                                children: [
                                  CustomTextField(
                                    label: 'Nombre',
                                    hintText: 'John',
                                    controller: nameController,
                                    isRequired: true,
                                  ),
                                  CustomTextField(
                                    label: 'Apellido',
                                    hintText: 'Doe',
                                    controller: lastNameController,
                                    isRequired: true,
                                  ),
                                ],
                              ),
                            EmailField(controller: emailController),
                            PasswordField(
                              controller: passwordController,
                              expansionController: expansionTileController,
                              isRegister: true,
                            ),
                          ]),
                          const SizedBox(height: 20),
                          CustomElevatedButton(
                              onPressed: () async {
                                if (_formRegisterKey.currentState!.validate()) {
                                  signup();
                                }
                              },
                              label: 'Registarse'),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 3,
                      children: [
                        Text(
                          "¿Ya tienes una cuenta?",
                          style: TextStyle(
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              goToSignIn(context);
                            },
                            child: Text(
                              "Inicia sesion aqui.",
                              style: TextStyle(
                                fontSize: height * 0.015,
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(height: height * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
