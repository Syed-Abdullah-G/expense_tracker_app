import 'package:hive/hive.dart';
import 'package:simple_app/models/expense.dart';

part 'content.g.dart';

@HiveType(typeId: 1)
class Content {
  @HiveField(0)
  List<Expense> items;

  Content({required this.items});
}
