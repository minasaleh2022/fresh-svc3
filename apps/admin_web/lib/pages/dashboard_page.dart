import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              _StatCard(title: 'Open Tickets', value: '42', icon: Icons.build),
              _StatCard(title: 'Technicians', value: '12', icon: Icons.engineering),
              _StatCard(title: 'Revenue (M)', value: '1.7', icon: Icons.payments),
              _StatCard(title: 'SLA %', value: '96.3', icon: Icons.speed),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 36),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
              ],
            )
          ],
        ),
      ),
    );
  }
}
