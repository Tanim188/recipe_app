class LoginModel {
  String email;
  String password;
  LoginModel({
    required this.email,
    required this.password,
  });
  @override
  String toString() {
    return "Login (Email: $email, Password: $password)";
  }
}
