import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LogoutService {
  final _baseURL = 'http://127.0.0.1:8000/api/';

  final storage = const FlutterSecureStorage();

  Future postDataLogout() async {
    String? value = await storage.read(key: 'token');
    try {
      final response = await http.post(
        Uri.parse('${_baseURL}auth/logout'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $value'},
      );
      await storage.delete(key: 'token');
    } catch (e) {
      print(e.toString());
    }
  }
}
