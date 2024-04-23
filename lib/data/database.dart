import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_app/models/expense.dart' as model;


class ExpenseDatabase {
  List<model.Expense> registeredExpenses = [];

  //reference the box
  

 

  // run this method if this is the first time opening this app
  void createInitialData() {
    var _myBox = Hive.box('expensebox');
    registeredExpenses = [
      model.Expense(
          title: 'Gym Membership',
          amount: 50.99,
          date: DateTime.now().toLocal().subtract(Duration(
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second)),
          category: model.Category.Bills),
      model.Expense(
          title: 'Cinemas',
          amount: 10.00,
          date: DateTime.now().toLocal().subtract(Duration(
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second)),
          category: model.Category.leisure)
    ];
  }

  //load the data from database
  void loadData() {
    var _myBox = Hive.box('expensebox');
    registeredExpenses = _myBox.get('expenses');
  }

  //update the database
  void updateDatabase() {
    var _myBox = Hive.box('expensebox');
    _myBox.put('expenses', registeredExpenses);
  }
}
