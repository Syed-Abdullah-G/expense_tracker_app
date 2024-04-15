import 'package:flutter/material.dart';
import 'package:simple_app/main.dart';
import 'package:simple_app/models/expense.dart';
import 'package:simple_app/widgets/expenses.dart';
import 'package:simple_app/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final void Function(Expense expense) onRemoveExpense;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
          key: ValueKey(expenses[index]),
          background: Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.error,borderRadius: BorderRadius.circular(20),),margin: Theme.of(context).cardTheme.margin,),
          onDismissed: (direction) {
            onRemoveExpense(expenses[index]);
          },
          child: ExpenseItem(expense: expenses[index])),
    );
  }
}
