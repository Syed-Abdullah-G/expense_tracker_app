import 'package:flutter/material.dart';
import 'package:simple_app/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title,style: Theme.of(context).textTheme.titleLarge,),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  
                ),const Spacer(),Row(children: [
                  Icon(categoryIcons[expense.category]),
                  const SizedBox(width: 8,),
                  Text(expense.formattedDate),
                ],),
              ],
            )
          ],
        ),
      ),
    );
  }
}
