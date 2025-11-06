import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/login_page.dart';
import 'shell/shell_layout.dart';
import 'pages/dashboard_page.dart';
import 'pages/reports_page.dart';
import 'pages/settings_page.dart';
import 'services/auth_service.dart';

final _auth = AuthService();

final router = GoRouter(
  redirect: (ctx, state) async {
    final loggedIn = await _auth.isLoggedIn();
    final loggingIn = state.fullPath == '/login';

    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && loggingIn) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (ctx, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (ctx, state, child) => ShellLayout(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (ctx, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/reports',
          builder: (ctx, state) => const ReportsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (ctx, state) => const SettingsPage(),
        ),
      ],
    ),
    // افتراضي: يروح للـ dashboard
    GoRoute(
      path: '/',
      redirect: (ctx, state) => '/dashboard',
    ),
  ],
);
