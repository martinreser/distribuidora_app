import 'package:distribuidora_app/auth/auth_error.dart';
import 'package:distribuidora_app/presentation/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../shared/widgets/buttons/custom_elevated_button.dart';
import '../shared/widgets/fields/fields.dart';
import 'auth_service.dart';

final _formLoginKey = GlobalKey<FormState>();

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final colorScheme = Theme.of(context).colorScheme;

    final errorText = useState<String?>(null);
    final expansionTileController = useExpansionTileController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final password = useState<String>("");

    goToSignUp(BuildContext context) {
      context.replace('/register');
    }

    goToHome(BuildContext context, UserModel user) {
      context.replace('/', extra: {'user': user});
    }

    signIn() async {
      final result =
          await auth.signIn(emailController.text, passwordController.text);
      if (context.mounted) {
        if (result is AsyncData && result.hasValue) {
          goToHome(context, result.value!);
        } else {
          if (result is AsyncError) {
            final error = result.error as AuthError;
            if (error.type == AuthErrorType.incorrectPassword) {
              errorText.value = error.message;
            }
            if (error.type == AuthErrorType.emailNotFound) {
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
                          goToSignUp(context);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Registrarse'),
                      ),
                    ],
                  );
                },
              );
            }
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
              key: _formLoginKey,
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
                            "Inicia Sesion",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Wrap(spacing: 20, runSpacing: 20, children: [
                            EmailField(controller: emailController),
                            PasswordField(
                              controller: passwordController,
                              expansionController: expansionTileController,
                              errorText: errorText.value,
                            ),
                          ]),
                          const SizedBox(height: 20),
                          CustomElevatedButton(
                              onPressed: () async {
                                if (_formLoginKey.currentState!.validate()) {
                                  signIn();
                                }
                              },
                              label: 'Ingresar'),
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
                          "¿Todavia no tienes una cuenta?",
                          style: TextStyle(
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              goToSignUp(context);
                            },
                            child: Text(
                              "Registrate aqui.",
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
