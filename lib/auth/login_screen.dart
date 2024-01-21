import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/auth/sign_up.dart';
import 'package:storage/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String? email;
  String? password;
  Future<void> getUser() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString('email') ?? 'admin';
      password = pref.getString('pass') ?? 'admin';
      // List<String> days = [];
      // days.add('W');
      // pref.setStringList('days', );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'password'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                    color: Colors.blueAccent,
                    child: const Text('Login'),
                    onPressed: () async {
                      await getUser();
                      if (emailController.text.isEmpty ||
                          passController.text.isEmpty) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please Enter Something'),
                        ));
                      } else {
                        if (emailController.text == email &&
                            passController.text == password) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Something wrong',
                              selectionColor: Colors.red,
                            ),
                          ));
                        }
                      }
                    }),
                CupertinoButton(
                    color: Colors.blueAccent,
                    child: const Text('Sign Up'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                    }),
              ],
            )
          ],
        ),
      )),
    );
  }
}
