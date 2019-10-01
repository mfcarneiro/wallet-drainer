import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart({this.recentTransactions});

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var transaction in recentTransactions) {
        if (transaction.date.day == weekday.day &&
            transaction.date.month == weekday.month &&
            transaction.date.year == weekday.year) {
          totalSum += transaction.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekday),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (value, valueItem) {
      return value += valueItem['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactionValues.map((chartData) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    chartData['day'],
                    chartData['amount'],
                    totalSpending == 0.0
                        ? 0.0
                        : (chartData['amount'] as double) / totalSpending,
                  ),
                );
              }).toList()),
        ),
      ),
    );
  }
}
