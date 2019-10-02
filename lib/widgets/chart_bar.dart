import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double totalSpend;

  ChartBar(this.label, this.spendingAmount, this.totalSpend);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(children: <Widget>[
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text('R\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ),
          Container(
            width: 16,
            height: constraints.maxHeight * 0.6,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Stack(
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * 0.6,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: totalSpend,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text('$label'),
            ),
          ),
        ]);
      },
    );
  }
}
