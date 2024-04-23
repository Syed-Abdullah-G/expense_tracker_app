import 'package:flutter/material.dart';
import 'package:simple_app/models/expense.dart';
import 'package:simple_app/widgets/chart/chart.dart';
import 'package:simple_app/widgets/expenses.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
    required this.amount,
    required this.registeredExpenses,
  });

  final String amount;
  final double fill;
  final List<Expense> registeredExpenses;

  @override
  Widget build(BuildContext context) {
    double calculateTotalAmount() {
      double totalAmount = 0.0;
      for (final expense in registeredExpenses) {
        totalAmount += expense.amount;
      }
      return totalAmount;
    }

    final amountinInt = double.parse(amount);
    final showcaseAmountforPercentage = (amountinInt / calculateTotalAmount());
    final showcaseAmountAfterConversion = showcaseAmountforPercentage * 100;
    final String showCasePercentageString =
        showcaseAmountAfterConversion.toStringAsFixed(2);

    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(children: [
          Container(
            width: double.infinity,
            child: FractionallySizedBox(
              heightFactor: fill,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.65),
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: Center(
            child: Text(
              amount,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ))
        ]),
      ),
    );
  }
}
