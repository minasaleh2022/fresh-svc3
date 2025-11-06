import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'admin@fresh.dev');
  final _pass = TextEditingController(text: '123456');
  bool _loading = false;
  String? _err;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 1,
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Fresh Admin', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text('Sign in to continue', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) => (v==null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _pass,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (v) => (v==null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    if (_err != null) Text(_err!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _loading ? null : _doLogin,
                      child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Login'),
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

  Future<void> _doLogin() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _err = null; });
    final ok = await AuthService().login(_email.text, _pass.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      setState(() => _err = 'Invalid credentials');
    }
  }
}
