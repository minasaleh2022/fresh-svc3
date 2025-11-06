import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  final String _user = 'admin@fresh.dev';
  final String _pass = '123456';

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final ok = email.trim() == _user && password == _pass;
    isLoggedIn.value = ok;
    return ok;
  }

  void logout() {
    isLoggedIn.value = false;
  }
}
