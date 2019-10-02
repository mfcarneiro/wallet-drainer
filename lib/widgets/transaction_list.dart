import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionList;
  final Function deleteTransaction;

  TransactionList(this.transactionList, this.deleteTransaction);

  Widget _buildNoResultPlaceholder() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.money_off,
              size: 55,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'No drainer expenses added yet!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return transactionList.isEmpty
        ? _buildNoResultPlaceholder()
        : ListView.builder(
            itemBuilder: (builderContext, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                elevation: 2,
                child: ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '- R\$${transactionList[index].amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    transactionList[index].title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${DateFormat().add_yMMMMEEEEd().format(transactionList[index].date)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTransaction(
                      transactionList[index].id,
                    ),
                  ),
                ),
              );
            },
            itemCount: transactionList.length,
          );
  }
}
