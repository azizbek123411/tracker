import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/controller/service/notifier.dart';
import 'package:tracker/repo/models/expanse_model.dart';

final expanseProvider =
    StateNotifierProvider<ExpanseNotifier, List<ExpanseModel>>(
  (ref) => ExpanseNotifier(),
);
