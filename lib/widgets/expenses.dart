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
import 'package:simple_app/data/database.dart';
import 'package:simple_app/widgets/expenses_list/expenses_list.dart';
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
  String _externalStorageDirectory = '';

  // reference the hive box

  var _myBox = Hive.box('expensebox');
  ExpenseDatabase db = ExpenseDatabase();

  final formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    // if this is the 1st time
    if (_myBox.get('expenses') == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }
    // TODO: implement initState
    super.initState();
    _getExternalStorageDirectory();
  }

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

        for (int i = 0; i < db.registeredExpenses.length; i++) {
          model.Expense expense = db.registeredExpenses[i];
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

  void _addExpense(model.Expense expense) {
    setState(() {
      db.registeredExpenses.add(expense);
    });
    db.updateDatabase();
  }

  void _removeExpense(model.Expense expense) {
    final expenseIndex = db.registeredExpenses.indexOf(expense);
    setState(() {
      db.registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                db.registeredExpenses.insert(expenseIndex, expense);
              });
            }),
        duration: Duration(seconds: 3),
        content: Text('Expense Deleted')));
    db.updateDatabase();
  }

  void showdb() {
    print(_myBox.values);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent =
        Center(child: Text('No expenses found. Start adding some'));

    if (db.registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: db.registeredExpenses, onRemoveExpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          OutlinedButton(
            onPressed: createExcel,
            child: Text(
              'Save as Excel',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          OutlinedButton(onPressed: showdb, child: Icon(Icons.add))
        ],
      ),
      body: flutter.Column(
        children: [
          Chart(
            expenses: db.registeredExpenses,
            registeredExpenses: db.registeredExpenses,
          ),
          Expanded(child: mainContent),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseOverlay,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
