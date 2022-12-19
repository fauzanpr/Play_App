import 'dart:async';

import 'package:api_app/models/categories.dart';
import 'package:api_app/services/categories_service.dart';
import 'package:api_app/services/logout_service.dart';
import 'package:api_app/views/add_category.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Categories> listCategories = [];
  final StreamController<List<Categories>> _categories = StreamController();
  Stream<List<Categories>> get categories => _categories.stream;

  int _page = 1;

  appendCategory(List<Categories> payload, bool isRefresh) async {
    // final current = await _categories.stream.last;
    // current.addAll(payload);
    if (isRefresh) {
      listCategories.clear();
      listCategories.addAll(payload);
    } else {
      listCategories.addAll(payload);
    }

    _categories.sink.add(listCategories);
  }

  final cs = CategoriesService();

  final logout = LogoutService();
  final ScrollController _scrollController = ScrollController();

  Future<void> getData({bool isRefresh = false}) async {
    final data = await cs.getData(_page);
    appendCategory(data, isRefresh);
    // listCategories.addAll(data);
    // setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        print('NEW DATA CALL');
        _page++;
        getData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
              child: StreamBuilder(
                stream: categories,
                builder: (context, snapshot) {
                  return ListView(
                    controller: _scrollController,
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
                                    height: 50,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          _page = 1;
                                          await cs.requestDelete(e);

                                          await getData(isRefresh: true);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          _page = 1;
                                          await Navigator.of(context).pushNamed(
                                            '/category/update',
                                            arguments: [e.id, e.name],
                                          );

                                          await getData(isRefresh: true);
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
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
