import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = List.generate(12, (i) => _ReportRow('INV-2024-${1000+i}', 'Center #${i+1}', i.isEven ? 'Closed' : 'Open'));
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reports', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Card(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Ticket')),
                DataColumn(label: Text('Center')),
                DataColumn(label: Text('Status')),
              ],
              rows: rows.map((r) => DataRow(cells: [
                DataCell(Text(r.id)),
                DataCell(Text(r.center)),
                DataCell(Chip(label: Text(r.status))),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportRow {
  final String id;
  final String center;
  final String status;
  _ReportRow(this.id, this.center, this.status);
}
