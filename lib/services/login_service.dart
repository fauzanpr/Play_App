import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  final _baseURL = 'http://127.0.0.1:8000/api/';

  final storage = new FlutterSecureStorage();

  Future postData(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseURL + 'auth/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
          'device_name': 'android',
        },
      );

      if (response.statusCode == 200) {
        print('tokennya : ' + response.body);

        await storage.write(
          key: 'token',
          value: jsonDecode(response.body)['token'],
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
