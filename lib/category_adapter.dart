import 'package:hive/hive.dart';
import 'package:simple_app/models/expense.dart';

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2; // Unique identifier for the adapter

  @override
  Category read(BinaryReader reader) {
    final index = reader.read() as int; // Read the name as String
    return Category.values[index];
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.write(obj.index); // Write the name of the Category
  }
}
