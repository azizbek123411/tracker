import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FilterType{
  all,
  today,
  thisWeek,
}


final filterProvider=StateProvider<FilterType>((ref)=>FilterType.all);