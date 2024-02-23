import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_mo/models/menu_model.dart';
import 'package:food_mo/models/order_model.dart';
import 'package:food_mo/models/outlet_model.dart';
import 'package:food_mo/providers/auth_provider.dart';
import 'package:food_mo/utils/config.dart';
import 'package:provider/provider.dart';

class OrderProvider extends ChangeNotifier {
  final dio = Dio();
  String? codeNotFound;
  final Map<String, List> _orderList = {
    'menu_id': [],
    'quantity': [],
  };

  Map<String, List> get orderList => _orderList;

  Future<OrderModel?> getOrder(BuildContext context, int id) async {
    try {
      final response = await dio.get(
        Config.orderUrl,
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${Provider.of<AuthProvider>(context, listen: false).token}',
          },
        ),
        queryParameters: {'id': id},
      );
      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load order');
      }
    } on DioException catch (e) {
      print(e);
      return null;
    }
  }

  Future<OutletModel?> getOutlet(BuildContext context, String code) async {
    try {
      final response = await dio.get(
        Config.outletUrl,
        queryParameters: {'code': code},
      );
      if (response.statusCode == 200) {
        return OutletModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load outlet');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return OutletModel.fromJson(e.response?.data);
      }
      print(e);
      return null;
    }
  }

  Future<MenuModel?> getMenu(BuildContext context, String code) async {
    try {
      final response = await dio.get(
        Config.menuUrl,
        queryParameters: {'code': code},
      );
      if (response.statusCode == 200) {
        return MenuModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return MenuModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load menu');
      }
    } on DioException catch (e) {
      print(e);
      return null;
    }
  }

  void submitCode(BuildContext context, TextEditingController codeController,
      GlobalKey<FormState> formKey) async {
    final code = codeController.text.toUpperCase();
    if (formKey.currentState!.validate()) {
      await getOutlet(context, code).then(
        (value) async {
          if (value != null) {
            if (value.data != null) {
              OutletModel outlet = value;
              MenuModel? menu = await getMenu(context, code);
              if (menu != null) {
                codeNotFound = null;
                notifyListeners();
                Navigator.pushNamed(
                  context,
                  '/outlet',
                  arguments: {
                    'outlet': outlet,
                    'menu': menu,
                  },
                );
              }
            } else if (value.message != null) {
              codeNotFound = value.message;
              notifyListeners();
            }
          }
        },
      );
    }
  }

  void incrementOrder(int menuId) {
    if (_orderList['menu_id']!.contains(menuId)) {
      int index = _orderList['menu_id']!.indexOf(menuId);
      _orderList['quantity']![index]++;
    } else {
      _orderList['menu_id']!.add(menuId);
      _orderList['quantity']!.add(1);
    }
    notifyListeners();
  }

  void decrementOrder(int menuId) {
    int index = _orderList['menu_id']!.indexOf(menuId);
    if (_orderList['quantity']![index] > 1) {
      _orderList['quantity']![index]--;
    } else {
      _orderList['menu_id']!.removeAt(index);
      _orderList['quantity']!.removeAt(index);
    }
    notifyListeners();
  }

  void removeOrder(int menuId) {
    int index = _orderList['menu_id']!.indexOf(menuId);
    _orderList['menu_id']!.removeAt(index);
    _orderList['quantity']!.removeAt(index);
    notifyListeners();
  }

  void clearOrder() {
    _orderList['menu_id']!.clear();
    _orderList['quantity']!.clear();
    // notifyListeners();
  }

  Future<void> submitOrder(BuildContext context, String code) async {
    if (_orderList['menu_id']!.isNotEmpty) {
      try {
        final response = await dio.post(
          Config.orderUrl,
          data: {
            'code': code,
            'menu_id': _orderList['menu_id'],
            'quantity': _orderList['quantity'],
          },
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${Provider.of<AuthProvider>(context, listen: false).token}',
            },
          ),
        );
        if (response.statusCode == 200) {
          clearOrder();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          throw Exception('Failed to submit order');
        }
      } on DioException catch (e) {
        print(e);
      }
    }
  }
}
