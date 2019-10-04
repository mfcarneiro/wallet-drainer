import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() {
  //! Can be a valid solution when the app has no reason to
  //! change the screen orientation
  //* SystemChrome.setPreferredOrientations(
  //*   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  //* );
  return runApp(Main());
}

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

class _AppState extends State<App> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    //! This method will call (initialize) didChangeAppLifecycleState method
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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

  double _calculateAppbarHeightSize(
    MediaQueryData mediaQuery,
    double appBarHeight,
    double statusbarHeight,
    double preferedHeightSize,
  ) {
    return (mediaQuery.size.height - appBarHeight - statusbarHeight) *
        preferedHeightSize;
  }

  void _openAddNewExpense() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return GestureDetector(
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(height: 400),
            child: NewTransaction(addNewTransaction: _addNewTransaction),
          ),
        );
      },
    );
  }

  Widget _buildApp(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);

    final appBar = AppBar(
      backgroundColor: Colors.green[600],
      centerTitle: true,
      title: const Text('Wallet Drainer'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
          onPressed: null,
        )
      ],
    );

    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: _calculateAppbarHeightSize(
                  mediaQuery,
                  appBar.preferredSize.height,
                  mediaQuery.padding.top,
                  0.3,
                ),
                child: Chart(recentTransactions: _recentTransactions),
              ),
              Container(
                height: _calculateAppbarHeightSize(
                  mediaQuery,
                  appBar.preferredSize.height,
                  mediaQuery.padding.top,
                  0.7,
                ),
                child: TransactionList(
                  _userTransactions,
                  _deleteTransaction,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _openAddNewExpense(),
          backgroundColor: theme.accentColor,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildApp(context);
  }
}
