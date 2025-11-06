import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key, required this.onNavigate, required this.current});

  final void Function(String route) onNavigate;
  final String current;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: _indexFor(current),
      groupAlignment: -0.8,
      onDestinationSelected: (i) => onNavigate(_routeFor(i)),
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Dashboard')),
        NavigationRailDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: Text('Reports')),
        NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
      ],
    );
  }

  int _indexFor(String route) {
    switch (route) {
      case '/': return 0;
      case '/reports': return 1;
      case '/settings': return 2;
      default: return 0;
    }
  }

  String _routeFor(int idx) {
    switch (idx) {
      case 0: return '/';
      case 1: return '/reports';
      case 2: return '/settings';
      default: return '/';
    }
  }
}
