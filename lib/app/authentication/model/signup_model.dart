class SignupModel {
  String name;
  String email;
  String password;
  bool isLogout;
  SignupModel({
    required this.name,
    required this.email,
    required this.password,
    required this.isLogout,
  });

  SignupModel copyWith({
    String? name,
    String? email,
    String? password,
    bool? isLogout,
  }) {
    return SignupModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isLogout: isLogout ?? this.isLogout,
    );
  }

  @override
  String toString() {
    return "Signup (Name: $name, Email: $email, Password: $password, isLogout: $isLogout)";
  }

  Map<String, String> toHiveFormat() {
    return {
      "name": name,
      "password": password,
      "isLogout": isLogout.toString()
    };
  }
}

enum UserLoginState { login, logout }
