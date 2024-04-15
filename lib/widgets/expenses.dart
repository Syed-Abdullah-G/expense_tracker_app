import 'package:flutter/material.dart';
import 'package:simple_app/widgets/expenses_list/expenses_list.dart';
import 'package:simple_app/models/expense.dart';
import 'package:simple_app/widgets/new_expense.dart';
import 'package:simple_app/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Gym Membership',
        amount: 50.99,
        date: DateTime.now(),
        category: Category.Bills),
    Expense(
        title: 'Cinemas',
        amount: 10.00,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
        duration: Duration(seconds: 3),
        content: Text('Expense Deleted')));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent =
        Center(child: Text('No expenses found. Start adding some'));

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [Chart(expenses: _registeredExpenses), Expanded(child: mainContent)],
      ),
    );
  }
}
