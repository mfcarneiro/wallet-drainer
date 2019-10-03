import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  //! These works with change() method on each InputText
  //! But will always show an warning because has immutable variables on a stateless Widget
  //! Instead could be use the controller property on the inputs
  // String expenseNameInput;
  // String expenseAmountInput;
  final Function addNewTransaction;

  NewTransaction({this.addNewTransaction});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _expenseNameController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  DateTime _selectedDate;

  void _submitNewExpense() {
    final enteredExpenseNameController = _expenseNameController.text;
    final enteredExpenseAmountController =
        num.parse(_expenseAmountController.text);

    if (enteredExpenseNameController.isEmpty ||
        enteredExpenseAmountController <= 0 ||
        _selectedDate == null) return;

    widget.addNewTransaction(
      enteredExpenseNameController,
      enteredExpenseAmountController,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
      ),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Expense name',
                    border: OutlineInputBorder(
                      gapPadding: 5.0,
                    ),
                  ),
                  controller: _expenseNameController,
                  //! same behavior of \/
                  //! onChanged: (value) => expenseNameInput = value,
                  onSubmitted: (_) =>
                      //! (_) Tells to flutter that I know that has a value to be used
                      //! but it will be ignored
                      //! Only when is ignored the current args
                      //! Will be needed to add parentesis on method
                      _submitNewExpense(),
                ),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    gapPadding: 5.0,
                  ),
                ),
                controller: _expenseAmountController,
                onSubmitted: (_) => _submitNewExpense(),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _selectedDate == null
                          ? 'No date chosen'
                          : DateFormat.yMMMEd().format(_selectedDate),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).accentColor,
                      child: Text('Choose a day'),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: Text('Add expense'),
                  onPressed: _submitNewExpense)
            ],
          ),
        ),
      ),
    );
  }
}
