import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:storage/add_user_screen.dart';
import 'package:storage/auth/database/user_database.dart';
import 'package:storage/auth/model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  // void scrollListener() async {
  //   if (scrollController.offset >=
  //           scrollController.position.maxScrollExtent / 2 &&
  //       !scrollController.position.outOfRange) {
  //     offset = users.length;
  //     getData();
  //     // if (controller.state!.length < controller.paginationModel.total!) {
  //     //   await controller.getFavorite();
  //     // }
  //   }
  // }

  Future<void> onRefresh() async {
    users = [];
    offset = 0;
    getData();
  }

  bool btScrolVisible = false;

  List<User> users = [];
  Future<void> getData() async {
    await UserDataBase().getData(offset: offset).then((value) {
      setState(() {
        users.addAll(value);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = [];
    getData();
  }

  int offset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        color: Colors.amber,
        onRefresh: onRefresh,
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.reverse) {
              if (!btScrolVisible) setState(() => btScrolVisible = true);
            } else if (notification.direction == ScrollDirection.forward) {
              if (btScrolVisible) setState(() => btScrolVisible = false);
            }

            return true;
          },
          child: ListView.builder(
            controller: scrollController,
            itemCount: users.length + 1,
            itemBuilder: (context, index) => index < users.length
                ? Card(
                    child: ListTile(
                      onTap: () async {
                        final userData = Faker(provider: FakerDataProvider());
                        await UserDataBase()
                            .updateData(User(
                                id: users[index].id,
                                name: userData.person.name(),
                                age: userData.person.random
                                    .integer(70, min: 18)))
                            .then((value) {
                          getData();
                        });
                      },
                      onLongPress: () async {
                        await UserDataBase()
                            .deleteData(deletUserId: users[index].id!)
                            .then((value) {
                          offset = offset;
                        });
                      },
                      leading: CircleAvatar(
                        child: Text(users[index].id.toString()),
                      ),
                      title: Text('name:${users[index].name} '),
                      subtitle: Text(
                          'Age:${users[index].age} | Date:${users[index].createAt}'),
                    ),
                  )
                : SizedBox(
                    child: TextButton(
                        onPressed: () {
                          offset = users.length;
                          getData();
                        },
                        child: const Text('See More...')),
                  ),
          ),
        ),
      ),
      floatingActionButton: btScrolVisible
          ? FloatingActionButton.small(
              onPressed: () {
                //  scrollController.jumpTo(0);
                scrollController.animateTo(0,
                    duration: const Duration(seconds: 1), curve: Curves.easeIn);
              },
              child: const Icon(Icons.keyboard_arrow_up),
            )
          : null,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditUserScreen(),
                ));
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
