import 'package:api_app/services/login_service.dart';
import 'package:api_app/views/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/homepage': (context) => HomePage(),
        '/login': (context) => MainApp(),
      },
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _emailController = TextEditingController(
    text: 'superadmin@gmail.com',
  );
  TextEditingController _passwordController = TextEditingController(
    text: 'password',
  );

  LoginService loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                bool response = await loginService.postData(
                    _emailController.text, _passwordController.text);

                print(response);

                if (response) {
                  print('pada main:' + response.toString());
                  Navigator.of(context).popAndPushNamed('/homepage');
                } else {
                  print('login gagal');
                }
              },
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
