import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_mo/models/menu_model.dart';
import 'package:food_mo/models/outlet_model.dart';
import 'package:food_mo/pages/check_out_page.dart';
import 'package:food_mo/pages/home_page.dart';
import 'package:food_mo/pages/login_page.dart';
import 'package:food_mo/pages/order_history_page.dart';
import 'package:food_mo/pages/outlet_page.dart';
import 'package:food_mo/providers/auth_provider.dart';
import 'package:food_mo/providers/order_list_provider.dart';
import 'package:food_mo/providers/order_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Provider.of<AuthProvider>(context, listen: false)
        .checkTokenValidity();
    setState(() {
      isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Mo',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/order_detail': (context) => OrderHistoryPage(
              id: ModalRoute.of(context)!.settings.arguments as int,
            ),
        '/outlet': (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final outlet = arguments['outlet'] as OutletModel;
          final menu = arguments['menu'] as MenuModel;

          return OutletPage(
            outlet: outlet,
            menu: menu,
          );
        },
        '/check_out': (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final code = arguments['code'] as String;
          final menu = arguments['menu'] as MenuModel;

          return CheckOutPage(
            code: code,
            menu: menu,
          );
        },
      },
      home: isLoggedIn ? HomePage() : LoginPage(),
    );
  }
}
