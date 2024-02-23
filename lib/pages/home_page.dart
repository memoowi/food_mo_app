import 'package:flutter/material.dart';
import 'package:food_mo/providers/auth_provider.dart';
import 'package:food_mo/widgets/code_field_box.dart';
import 'package:food_mo/widgets/hero_login.dart';
import 'package:food_mo/widgets/order_history_box.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).logout().then((value) {
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn ==
          false) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroLogin(
              username: Provider.of<AuthProvider>(context).user?.name,
            ),
            const CodeFieldBox(),
            const OrderHistoryBox(),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text('Food Mo'),
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () => logout(context),
          icon: const Icon(Icons.logout),
        )
      ],
    );
  }
}
