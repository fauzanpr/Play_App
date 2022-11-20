import 'package:api_app/models/categories.dart';
import 'package:api_app/services/categories_service.dart';
import 'package:api_app/services/logout_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Categories> listCategories = [];
  final cs = CategoriesService();

  final logout = LogoutService();

  getData() async {
    listCategories = await cs.getData();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              logout.postDataLogout().then(
                    (value) => Navigator.of(context).popAndPushNamed('/login'),
                  );
            },
            child: const Text('Logout'),
          ),
          Expanded(
            child: FutureBuilder(
              future: cs.getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    children: (snapshot.data ?? [])
                        .map(
                          (e) => Container(
                            padding: EdgeInsets.fromLTRB(10, 30, 10, 100),
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}