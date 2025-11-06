import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _k = 'logged_in';

  Future<bool> isLoggedIn() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_k) ?? false;
  }

  Future<void> login(String u, String p) async {
    // Demo: أي بيانات تمشي
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_k, true);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_k, false);
  }
}
