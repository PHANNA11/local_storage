import 'dart:developer';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:storage/auth/database/user_database.dart';
import 'package:storage/auth/model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  Future<void> getData() async {
    await UserDataBase().getData().then((value) {
      setState(() {
        users = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            onLongPress: () async {
              await UserDataBase()
                  .deleteData(deletUserId: users[index].id!)
                  .then((value) => getData());
            },
            leading: CircleAvatar(
              child: Text(users[index].id.toString()),
            ),
            title: Text('name:${users[index].name} '),
            subtitle: Text('Age:${users[index].age}'),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            final userData = Faker(provider: FakerDataProvider());
            await UserDataBase()
                .inserData(User(
                    name: userData.person.name(),
                    age: userData.person.random.integer(70, min: 18)))
                .then((value) {
              getData();
            });
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: const Center(child: Text('Add New')),
          ),
        ),
      ),
    );
  }
}
