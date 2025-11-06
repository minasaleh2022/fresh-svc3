import 'package:flutter/material.dart';
import 'router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fresh Admin',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFDB1E2F), // أحمر Fresh
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F5F7),
      ),
      routerConfig: router,
    );
  }
}
