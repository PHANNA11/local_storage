import 'dart:developer';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:storage/auth/database/user_database.dart';
import 'package:storage/auth/model/user_model.dart';

class AddEditUserScreen extends StatefulWidget {
  const AddEditUserScreen({super.key});

  @override
  State<AddEditUserScreen> createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends State<AddEditUserScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Add User'),
        actions: [
          IconButton(
              onPressed: () async {
                final userData = Faker(provider: FakerDataProvider());
                setState(() {
                  nameController.text = userData.person.name();
                  ageController.text =
                      userData.person.random.integer(70, min: 18).toString();
                });
              },
              icon: const Icon(Icons.autorenew_outlined))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: ageController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter Age'),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            await UserDataBase().inserData(User(
                name: nameController.text,
                age: int.parse(ageController.text),
                createAt: DateTime.now().toString()));
            Navigator.pop(context);
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
