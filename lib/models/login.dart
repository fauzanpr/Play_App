class Login {
  final String email;
  final String password;
  final String device_name;

  const Login({
    required this.email,
    required this.password,
    required this.device_name,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'],
      password: json['password'],
      device_name: json['device_name'],
    );
  }
}
