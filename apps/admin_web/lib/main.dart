import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'widgets/sidebar.dart';
import 'pages/dashboard_page.dart';
import 'pages/reports_page.dart';
import 'pages/settings_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fresh Admin',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4F46E5),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const _Protected(child: _Shell(child: DashboardPage(), currentRoute: '/'));
            break;
          case '/reports':
            page = const _Protected(child: _Shell(child: ReportsPage(), currentRoute: '/reports'));
            break;
          case '/settings':
            page = const _Protected(child: _Shell(child: SettingsPage(), currentRoute: '/settings'));
            break;
          case '/login':
            page = const LoginPage();
            break;
          default:
            page = const _Protected(child: _Shell(child: DashboardPage(), currentRoute: '/'));
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
      initialRoute: '/',
    );
  }
}

class _Protected extends StatelessWidget {
  const _Protected({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AuthService().isLoggedIn,
      builder: (context, logged, _) {
        if (!logged) return const LoginPage();
        return child;
      },
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.child, required this.currentRoute});
  final Widget child;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fresh Admin'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () => AuthService().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: AdminSidebar(
              current: currentRoute,
              onNavigate: (route) {
                if (ModalRoute.of(context)?.settings.name != route) {
                  Navigator.of(context).pushReplacementNamed(route);
                }
              },
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
