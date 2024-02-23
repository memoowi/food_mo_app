import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_mo/models/order_list_model.dart';
import 'package:food_mo/providers/auth_provider.dart';
import 'package:food_mo/utils/config.dart';
import 'package:provider/provider.dart';

class OrderListProvider extends ChangeNotifier {
  final dio = Dio();
  List _orderList = [];
  List get orderList => _orderList;

  Future<void> getOrderList(BuildContext context) async {
    try {
      final response = await dio.get(
        Config.orderListUrl,
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${Provider.of<AuthProvider>(context, listen: false).token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        _orderList = OrderListModel.fromJson(response.data).data!;
        notifyListeners();
      }
    } on DioException catch (e) {
      print(e);
    }
  }
}
