import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import 'transaction_history_screen.dart';
import 'set_budget_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalBalance = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;

  // List to store transactions
  List<Map<String, Object>> transactions = [];

  void _addTransaction(double amount, String description, String category) {
    setState(() {
      totalExpenses += amount;
      totalBalance -= amount;
      // Add transaction to the list
      transactions.add({
        'amount': amount,
        'description': description,
        'category': category,
      });
    });

    // Show a success popup message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _setBudget(double budget) {
    setState(() {
      totalBalance = budget;
      totalIncome = budget;
    });

    // Show a success popup message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Budget set successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Finance Tracker'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent.withOpacity(0.2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildSummaryCard(),  // Changed from Expanded to a direct call
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent.withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_money),
                      color: Colors.teal,
                      onPressed: () async {
                        try {
                          final double? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetBudgetScreen(),
                            ),
                          );
                          if (result != null) {
                            _setBudget(result);
                          }
                        } catch (e) {
                          print("Error setting budget: $e");
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  'Rs.${totalBalance.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                Divider(thickness: 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Income', style: TextStyle(fontSize: 16.0)),
                        SizedBox(height: 4.0),
                        Text(
                          'Rs.${totalIncome.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expenses', style: TextStyle(fontSize: 16.0)),
                        SizedBox(height: 4.0),
                        Text(
                          'Rs.${totalExpenses.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Transaction'),
            onPressed: () async {
              try {
                final Map<String, Object>? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(),
                  ),
                );

                // If a transaction is returned, update values
                if (result != null) {
                  double amount = result['amount'] as double;
                  String description = result['description'] as String;
                  String category = result['category'] as String;

                  _addTransaction(amount, description, category);
                }
              } catch (e) {
                print("Error adding transaction: $e");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.history),
            label: Text('View History'),
            onPressed: () {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryScreen(
                      transactions: transactions,
                    ),
                  ),
                );
              } catch (e) {
                print("Error viewing history: $e");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
