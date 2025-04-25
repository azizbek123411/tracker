import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/controller/notifier.dart';
import 'package:tracker/models/expanse_model.dart';

final expanseProvider =
    StateNotifierProvider<ExpanseNotifier, List<ExpanseModel>>(
  (ref) => ExpanseNotifier(),
);
