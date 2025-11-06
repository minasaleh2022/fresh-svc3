import 'dart:html' as html;
import 'package:flutter/material.dart';

void main() {
  runApp(const FreshAdminApp());
}

class AuthService extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  AuthService() {
    _loggedIn = html.window.localStorage['fresh_logged_in'] == '1';
  }

  void login(String user, String pass) {
    if (user.isNotEmpty && pass.isNotEmpty) {
      _loggedIn = true;
      html.window.localStorage['fresh_logged_in'] = '1';
      notifyListeners();
    }
  }

  void logout() {
    _loggedIn = false;
    html.window.localStorage.remove('fresh_logged_in');
    notifyListeners();
  }
}

class FreshAdminApp extends StatefulWidget {
  const FreshAdminApp({super.key});

  @override
  State<FreshAdminApp> createState() => _FreshAdminAppState();
}

class _FreshAdminAppState extends State<FreshAdminApp> {
  final auth = AuthService();
  final _routerKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    auth.addListener(() {
      setState(() {});
    });
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Widget page;
    bool protected = true;

    switch (settings.name) {
      case '/':
      case '/dashboard':
        page = const DashboardPage();
        break;
      case '/reports':
        page = const ReportsPage();
        break;
      case '/settings':
        page = SettingsPage(onLogout: auth.logout);
        break;
      case '/login':
        protected = false;
        page = LoginPage(onLogin: auth.login);
        break;
      default:
        page = const NotFoundPage();
        break;
    }

    final isLogin = settings.name == '/login';
    if (!auth.loggedIn && !isLogin && protected) {
      page = LoginPage(onLogin: auth.login, redirectTo: settings.name ?? '/');
    }

    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fresh Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE51E2A)),
        useMaterial3: true,
      ),
      navigatorKey: _routerKey,
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

class AdminScaffold extends StatelessWidget {
  final int selectedIndex;
  final Widget child;
  const AdminScaffold({super.key, required this.selectedIndex, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 900;

    final destinations = const [
      NavigationRailDestination(icon: Icon(Icons.space_dashboard_outlined), selectedIcon: Icon(Icons.space_dashboard), label: Text('Dashboard')),
      NavigationRailDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: Text('Reports')),
      NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
    ];

    void go(int idx) {
      switch (idx) {
        case 0: Navigator.of(context).pushReplacementNamed('/dashboard'); break;
        case 1: Navigator.of(context).pushReplacementNamed('/reports'); break;
        case 2: Navigator.of(context).pushReplacementNamed('/settings'); break;
      }
    }

    if (isWide) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fresh Admin')),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: go,
              labelType: NavigationRailLabelType.all,
              destinations: destinations,
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Fresh Admin')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Center(child: Text('Fresh Admin'))),
            ListTile(leading: const Icon(Icons.space_dashboard), title: const Text('Dashboard'), selected: selectedIndex==0, onTap: ()=> go(0)),
            ListTile(leading: const Icon(Icons.assignment), title: const Text('Reports'), selected: selectedIndex==1, onTap: ()=> go(1)),
            ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), selected: selectedIndex==2, onTap: ()=> go(2)),
          ],
        ),
      ),
      body: child,
    );
  }
}

class LoginPage extends StatefulWidget {
  final void Function(String, String) onLogin;
  final String? redirectTo;
  const LoginPage({super.key, required this.onLogin, this.redirectTo});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Fresh Admin Login', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _userCtrl,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (v)=> (v==null || v.isEmpty) ? 'Enter username' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (v)=> (v==null || v.isEmpty) ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _loading ? null : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(()=> _loading=true);
                        await Future.delayed(const Duration(milliseconds: 400));
                        widget.onLogin(_userCtrl.text, _passCtrl.text);
                        if (!mounted) return;
                        Navigator.of(context).pushReplacementNamed(widget.redirectTo ?? '/dashboard');
                      },
                      child: _loading ? const SizedBox(height:20,width:20,child:CircularProgressIndicator(strokeWidth:2)) : const Text('Sign in'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      selectedIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16, runSpacing: 16,
              children: const [
                _KpiCard(title: 'Open Tickets', value: '128'),
                _KpiCard(title: 'Completed Today', value: '47'),
                _KpiCard(title: 'Technicians Online', value: '34'),
                _KpiCard(title: 'Avg. Resolution (hrs)', value: '3.2'),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Activity', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    const _ActivityRow(icon: Icons.check_circle, text: 'Ticket #123456 closed by Ahmed'),
                    const _ActivityRow(icon: Icons.build, text: 'Spare part PR-992 scanned in Warehouse 3'),
                    const _ActivityRow(icon: Icons.schedule, text: 'Technician Sara started shift in Nasr City'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      selectedIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reports', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: [
                ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.download), label: const Text('Tickets (CSV)')),
                ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.download), label: const Text('Inventory (CSV)')),
                ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.download), label: const Text('Technicians KPIs (CSV)')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final VoidCallback onLogout;
  const SettingsPage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      selectedIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            const Text('Tenant: Fresh (demo)\nEnvironment: production'),
            const SizedBox(height: 24),
            OutlinedButton.icon(onPressed: onLogout, icon: const Icon(Icons.logout), label: const Text('Log out'))
          ],
        ),
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 56, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 12),
          const Text('Page not found'),
          const SizedBox(height: 8),
          TextButton(onPressed: ()=> Navigator.of(context).pushReplacementNamed('/dashboard'), child: const Text('Back to Dashboard'))
        ],
      )),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  const _KpiCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ActivityRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
