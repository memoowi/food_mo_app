import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_mo/models/token_models.dart';
import 'package:food_mo/models/user_model.dart';
import 'package:food_mo/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final dio = Dio();
  String _token = '';
  UserModel? _user;
  bool isLoggedIn = false;
  String? errorMessage;

  String get token => _token;
  UserModel? get user => _user;

  void setToken(String token) {
    _token = token;
  }

  Future<void> setUser() async {
    try {
      final response = await dio.get(
        Config.userUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );
      if (response.statusCode == 200) {
        _user = UserModel.fromJson(response.data);
        isLoggedIn = true;
        notifyListeners();
      } else {
        throw Exception('Failed to get user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkTokenValidity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) {
        setToken(token);
        await setUser();
        notifyListeners();
      } else {
        setToken('');
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await dio.post(
        Config.loginUrl,
        data: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        String token = TokenModel.fromJson(response.data).token!;
        setToken(token);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        await setUser();
        notifyListeners();
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
          errorMessage = TokenModel.fromJson(e.response?.data).message;
          notifyListeners();
        }
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    }
  }

  Future<void> logout() async {
    try {
      final response = await dio.post(
        Config.logoutUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );
      if (response.statusCode == 200) {
        setToken('');
        isLoggedIn = false;
        _user = null;
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('token');
        notifyListeners();
      } else {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      rethrow;
    }
  }
}
