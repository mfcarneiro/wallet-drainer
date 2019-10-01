import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
      String expenseName, num expenseAmount, DateTime chosenDate) {
    final newTransaction = Transaction(
      title: expenseName,
      amount: expenseAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere(
        (transaction) => transaction.id == id,
      );
    });
  }

  void _openAddNewExpense() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return GestureDetector(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: 400),
            child: NewTransaction(addNewTransaction: _addNewTransaction),
          ),
        );
      },
    );
  }

  Widget _buildApp(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[600],
          centerTitle: true,
          title: Text('Wallet Drainer'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              onPressed: null,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Chart(recentTransactions: _recentTransactions),
              TransactionList(_userTransactions, _deleteTransaction),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _openAddNewExpense(),
          backgroundColor: Theme.of(context).accentColor,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildApp(context);
  }
}
