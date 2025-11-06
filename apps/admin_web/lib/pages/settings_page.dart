import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool dark = false;
  String tenant = 'Default';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('Dark theme'),
                    value: dark,
                    onChanged: (v) => setState(() => dark = v),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Tenant'),
                    value: tenant,
                    items: const [
                      DropdownMenuItem(value: 'Default', child: Text('Default')),
                      DropdownMenuItem(value: 'Pro', child: Text('Pro')),
                      DropdownMenuItem(value: 'Enterprise', child: Text('Enterprise')),
                    ],
                    onChanged: (v) => setState(() => tenant = v ?? tenant),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!'))),
                    child: const Text('Save changes'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
