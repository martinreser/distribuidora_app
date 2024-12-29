class AuthError {
  final String title;
  final String message;
  final AuthErrorType type;

  AuthError(
      {this.title = 'Error inesperado',
      required this.message,
      required this.type});
}

enum AuthErrorType {
  emailAlreadyRegistered,
  emailNotFound,
  incorrectPassword,
  userDataNotFound,
  unknown,
}
