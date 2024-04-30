import 'package:hive/hive.dart';
import 'package:simple_app/models/expense.dart';

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0; // Unique identifier for the adapter

  @override
  Expense read(BinaryReader reader) {
    return Expense(
      title: reader.read(),
      amount: reader.read(),
      date: reader.read(),
      category: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer.write(obj.title);
    writer.write(obj.amount);
    writer.write(obj.date);
    writer.write(obj.category);
  }
}
