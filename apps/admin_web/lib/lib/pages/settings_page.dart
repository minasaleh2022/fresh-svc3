import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          const Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Enable notifications'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Company name'),
            subtitle: const Text('Fresh'),
            trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Material 3'),
            trailing: TextButton(onPressed: () {}, child: const Text('Change')),
          ),
        ],
      ),
    );
  }
}
