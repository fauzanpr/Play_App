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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginService loginService = LoginService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 0, 102, 255)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 48, 73, 209),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 0, 102, 255)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 48, 73, 209),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 28, 0, 170)),
                    ),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        bool response = await loginService.postData(
                            _emailController.text, _passwordController.text);

                        print(response);

                        if (response) {
                          print('pada main:' + response.toString());
                          Navigator.of(context).popAndPushNamed('/homepage');
                        } else {}
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
