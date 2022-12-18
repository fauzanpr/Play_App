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
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await Navigator.pushNamed(context, '/category/add');
          if (data != null) {
            await getData();
            setState(() {});
          }
        },
        backgroundColor: const Color(0xFF6777EF),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                logout.postDataLogout().then(
                      (value) =>
                          Navigator.of(context).popAndPushNamed('/login'),
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
                            (e) => Card(
                              color: const Color(0xFF6777EF),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await cs.requestDelete(e);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            var data = await Navigator.of(
                                                    context)
                                                .pushNamed('/category/update',
                                                    arguments: [e.id, e.name]);
                                            if (data != null) {
                                              await getData();
                                              setState(() {});
                                            }
                                          },
                                          color: Colors.brown,
                                          icon: const Icon(Icons.edit),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}
