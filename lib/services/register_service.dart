import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  final _baseURL = 'http://127.0.0.1:8000/api/';

  final storage = new FlutterSecureStorage();

  Future postRegister(String name, String email, String password,
      String confirm_password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseURL + 'auth/register'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirm_password,
          'device_name': 'fauzan',
        },
      );

      if (response.statusCode == 200) {
        print('tokennya register adalah : ' + response.body);

        await storage.write(
          key: 'token',
          value: jsonDecode(response.body)['token'],
        );
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
