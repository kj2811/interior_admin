class User {
  String email;
  String password;
  String roleId;

  User({
    required this.email,
    required this.password,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      roleId: json['role_id'],
    );
  }
}
