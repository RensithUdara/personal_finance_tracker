import 'package:flutter/material.dart';

class BudgetSettingsScreen extends StatefulWidget {
  const BudgetSettingsScreen({super.key});

  @override
  _BudgetSettingsScreenState createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  final TextEditingController _budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(labelText: 'Monthly Budget'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                double? budget = double.tryParse(_budgetController.text);
                if (budget != null) {
                  // Save the budget value
                }
              },
              child: const Text('Save Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
