class UserModel {
  final String name;
  final String lastname;
  final String email;

  UserModel({required this.name, required this.lastname, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastname': lastname,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      lastname: map['lastname'],
      email: map['email'],
    );
  }
}
