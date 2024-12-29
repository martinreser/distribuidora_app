import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distribuidora_app/presentation/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_error.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _fire = FirebaseFirestore.instance;

  Future<AsyncValue<UserModel>> createUser(
      String name, String lastname, String email, String password) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _fire
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.size >= 1) {
        return AsyncValue.error(
          AuthError(
            title: 'Cuenta ya registrada',
            message: 'Ya existe una cuenta asociada a este correo electronico.',
            type: AuthErrorType.incorrectPassword,
          ),
          StackTrace.current,
        );
      } else {
        UserCredential credentials = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = credentials.user!.uid;
        UserModel usermodel = UserModel(
          name: name,
          lastname: lastname,
          email: email,
        );

        await _fire.collection('users').doc(uid).set(usermodel.toMap());
        return AsyncData(usermodel);
      }
    } catch (e) {
      return AsyncValue.error(
        AuthError(
          message: 'Hubo un error al registrar el usuario. Intente nuevamente',
          type: AuthErrorType.unknown,
        ),
        StackTrace.current,
      );
    }
  }

  Future<AsyncValue<UserModel>> signIn(String email, String password) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _fire
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.size == 0) {
        return AsyncValue.error(
          AuthError(
            title: 'Cuenta no registrada',
            message: 'El correo $email no existe en el sistema.',
            type: AuthErrorType.emailNotFound,
          ),
          StackTrace.current,
        );
      } else {
        try {
          final credentials = await _auth.signInWithEmailAndPassword(
              email: email, password: password);

          String uid = credentials.user!.uid;
          DocumentSnapshot<Map<String, dynamic>> docSnapshot =
              await _fire.collection('users').doc(uid).get();

          if (docSnapshot.exists) {
            return AsyncValue.data(UserModel.fromMap(docSnapshot.data()!));
          } else {
            return AsyncValue.error(
              AuthError(
                message:
                    'Hubo un error al buscar el usuario. Intente nuevamente',
                type: AuthErrorType.userDataNotFound,
              ),
              StackTrace.current,
            );
          }
        } catch (e) {
          return AsyncValue.error(
            AuthError(
              message: 'La contraseña es incorrecta.',
              type: AuthErrorType.incorrectPassword,
            ),
            StackTrace.current,
          );
        }
      }
    } catch (e) {
      return AsyncValue.error(
        AuthError(
          message: 'Hubo un error al buscar el usuario. Intente nuevamente',
          type: AuthErrorType.unknown,
        ),
        StackTrace.current,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error: $e');
      return;
    }
  }
}
