import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tracker/repository/models/expanse_model.dart';

class ExpanseNotifier extends StateNotifier<List<ExpanseModel>>{
  ExpanseNotifier() : super([]){
    _loadExpanses();
  }

  final box=Hive.box<ExpanseModel>('expenses');


  void _loadExpanses(){
    state=box.values.toList();
  }

  void addExpanse(ExpanseModel expanse){
    box.put(expanse.id, expanse);
    state=[...state,expanse];
  }
  void deleteExpanse(String id){
    box.delete(id);
    state=state.where((expanse)=>expanse.id != id).toList();
  }

  void updateExpanse(ExpanseModel expanse){
    box.put(expanse.id, expanse);
    state=[
      for(final e in state)
        if(e.id==expanse.id)expanse else e,
      
    ];
  }

  void clearAllExpanses(){
    box.clear();
    state=[];
  }
}