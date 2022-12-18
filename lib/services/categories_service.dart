import 'dart:io';

import 'package:api_app/models/categories.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesService {
  final _baseURL = 'http://127.0.0.1:8000/api/';

  final storage = const FlutterSecureStorage();

  Future<List<Categories>> getData() async {
    String? value = await storage.read(key: 'token');
    print('value ==> $value');
    if (value == null) {
      throw Exception('ERROR VALUE NULL');
    }
    final response = await http.get(
      Uri.parse('${_baseURL}category'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $value',
      },
    );

    final payload = (jsonDecode(response.body)['data'] as List);

    return payload.map((e) => Categories.fromJson(e)).toList();
  }

  Future addCategory(String name) async {
    String? token = await storage.read(key: 'token');
    try {
      final response = await http.post(
        Uri.parse(_baseURL + 'category'),
        headers: {
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: {
          'name': name,
        },
      );

      print('atasss : ' + response.body);

      if (response.statusCode == 201) {
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future requestDelete(Categories category) async {
    var apiUrl = Uri.parse('${_baseURL}category/${category.id}');

    final value = await storage.read(key: 'token');

    final response = await http.delete(apiUrl, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $value',
    });

    return response;
  }
}
