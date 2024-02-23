import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_mo/providers/auth_provider.dart';
import 'package:food_mo/widgets/hero_login.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    } else if (value.length < 3) {
      return 'Username must be at least 3 characters';
    } else {
      return null;
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else {
      return null;
    }
  }

  void togglePassword() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void login() {
    if (formKey.currentState!.validate()) {
      final username = usernameController.text;
      final password = passwordController.text;
      print('Username: $username, Password: $password');
      Provider.of<AuthProvider>(context, listen: false)
          .login(username, password)
          .then((value) {
        if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn ==
            true) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroLogin(isLoginPage: true),
            SizedBox(height: 40.0),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    Consumer(builder: (context, AuthProvider provider, _) {
                      if (provider.errorMessage != null) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          padding: EdgeInsets.all(10.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.red,
                          ),
                          child: Text(
                            provider.errorMessage.toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                    TextFormField(
                      controller: usernameController,
                      validator: usernameValidator,
                      decoration: InputDecoration(
                        hintText: 'Username or Email',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(CupertinoIcons.person_alt_circle_fill),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscureText,
                      validator: passwordValidator,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(CupertinoIcons.lock_circle_fill),
                        suffixIcon: IconButton(
                          onPressed: togglePassword,
                          icon: Icon(
                            obscureText
                                ? CupertinoIcons.eye_fill
                                : CupertinoIcons.eye_slash_fill,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: login,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
