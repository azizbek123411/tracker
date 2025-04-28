import 'package:hive/hive.dart';
part 'expanse_model.g.dart';

@HiveType(typeId: 0)
class ExpanseModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
 


  ExpanseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,

  });

  ExpanseModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,

  }) {
    return ExpanseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
   
    
    );
  }
}
