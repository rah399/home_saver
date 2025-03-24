import 'package:flutter/material.dart';

class TotalScreen extends StatelessWidget {
  final Map<String, double> nameTotals;

  TotalScreen({required this.nameTotals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Total Amounts by Name")),
      body: ListView.builder(
        itemCount: nameTotals.length,
        itemBuilder: (context, index) {
          String name = nameTotals.keys.elementAt(index);
          double total = nameTotals[name]!;
          return ListTile(
            title: Text(
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Total: \$${total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
