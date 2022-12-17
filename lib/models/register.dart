// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Register {
  final String name;
  final String email;
  final String password;
  final String password_confirmation;
  final String device_name;
  
  Register({
    required this.name,
    required this.email,
    required this.password,
    required this.password_confirmation,
    required this.device_name,
  });

  Register copyWith({
    String? name,
    String? email,
    String? password,
    String? password_confirmation,
    String? device_name,
  }) {
    return Register(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      password_confirmation:
          password_confirmation ?? this.password_confirmation,
      device_name: device_name ?? this.device_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation,
      'device_name': device_name,
    };
  }

  factory Register.fromMap(Map<String, dynamic> map) {
    return Register(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      password_confirmation: map['password_confirmation'] as String,
      device_name: map['device_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Register.fromJson(String source) =>
      Register.fromMap(json.decode(source) as Map<String, dynamic>);
}
