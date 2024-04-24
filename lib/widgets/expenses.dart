import 'dart:io';
import 'dart:math';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_app/widgets/expenses_list/expenses_list.dart';
import 'package:simple_app/models/expense.dart';
import 'package:simple_app/models/expense.dart' as model;
import 'package:simple_app/widgets/new_expense.dart';
import 'package:simple_app/widgets/chart/chart.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  String _externalStorageDirectory = "";
  final formatter = DateFormat('dd/MM/yyyy');
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Gym Membership',
        amount: 50.99,
        date: DateTime.now(),
        category: model.Category.Bills),
    Expense(
        title: 'Cinemas',
        amount: 10.00,
        date: DateTime.now(),
        category: model.Category.leisure)
  ];

  Future<void> _getExternalStorageDirectory() async {
    try {
      String directory = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS,
      );
      setState(() {
        _externalStorageDirectory = directory;
      });
    } catch (e) {
      print('Error getting external storage directory: $e');
    }
  }

  final _storagePermission = Permission.storage;

  Future<void> createExcel() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await _storagePermission.request();
      if (status.isDenied ||
          status.isRestricted ||
          status.isPermanentlyDenied) {
        // If permission was previously denied, request permission again
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        print('Storage permission given...');
        final Workbook workbook = new Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        //set column headers
        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('B1').setText('Amount');
        sheet.getRangeByName('C1').setText('Date');
        sheet.getRangeByName('D1').setText('Category');
        //writing data

        for (int i = 0; i < _registeredExpenses.length; i++) {
          model.Expense expense = _registeredExpenses[i];
          sheet.getRangeByIndex(i + 2, 1).setText(expense.title);
          sheet.getRangeByIndex(i + 2, 2).setNumber(expense.amount);
          sheet.getRangeByIndex(i + 2, 3).setDateTime(expense.date);
          sheet.getRangeByIndex(i + 2, 3).numberFormat = 'dd/mm/yyyy';
          sheet
              .getRangeByIndex(i + 2, 4)
              .setText(expense.category.name.toString());
        }

        final List<int> bytes = workbook.saveAsStream();
        workbook.dispose();

        if (_externalStorageDirectory.isNotEmpty) {
          var time = DateTime.now().millisecondsSinceEpoch;
          var path = '$_externalStorageDirectory/image-$time.xlsx';
          var file = File(path);
          await file.writeAsBytes(bytes);
          print('Excel file saved at: $path');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              action: SnackBarAction(
                label: 'Open File',
                onPressed: () async {
                  try {
                    await OpenFile.open(path);
                  } catch (error) {
                    print('Error opening the saved file: $error');
                  }
                },
              ),
              content:
                  Text('Excel Files are stored at: $_externalStorageDirectory'),
              duration: Duration(seconds: 15),
            ),
          );
          //code to open the saved file
        } else {
          print('External storage directory is not available');
        }
      } else {
        print('Storage permission not granted');
      }
    }
  }

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
          OutlinedButton(
              onPressed: createExcel,
              child: Text(
                'Save as Excel',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ))
        ],
      ),
      body: flutter.Column(
        children: [
          Chart(
              expenses: _registeredExpenses,
              registeredExpenses: _registeredExpenses),
          Expanded(child: mainContent),
          FloatingActionButton(
              onPressed: _openAddExpenseOverlay, child: Icon(Icons.add)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
