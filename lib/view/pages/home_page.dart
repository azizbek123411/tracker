import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/controller/provider/expanse_provider.dart';
import 'package:tracker/controller/provider/fliter_provider.dart';
import 'package:tracker/repo/models/expanse_model.dart';
import 'package:tracker/view/widgets/stats_widget.dart';
import 'package:uuid/uuid.dart';

import '../widgets/expanse_dialog.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final expanses = ref.watch(expanseProvider);
    final filteredExpanses = expanses.where((expanse) {
      final now = DateTime.now();
      if (filter == FilterType.today) {
        return expanse.date.year == now.year &&
            expanse.date.month == now.month &&
            expanse.date.day == now.day;
      } else if (filter == FilterType.thisWeek) {
        final weekAgo = now.subtract(
          Duration(days: 7),
        );
        return expanse.date.isAfter(weekAgo);
      }
      return true;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ref.read(expanseProvider.notifier).clearAllExpanses();
            },
            icon: Icon(
              Icons.delete_forever,
            ),
          ),
          PopupMenuButton<FilterType>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) =>
                ref.read(filterProvider.notifier).state = value,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: FilterType.all,
                  child: Text("All"),
                ),
                PopupMenuItem(
                  value: FilterType.today,
                  child: Text('Today'),
                ),
                PopupMenuItem(
                  value: FilterType.thisWeek,
                  child: Text('This Week'),
                ),
              ];
            },
          )
        ],
        title: Text("Expanse Tracker"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: StatsWidget(expanses: filteredExpanses)),
          Divider(),
          Expanded(
            child: expanses.isEmpty
                ? const Center(
                    child: Text('No expanses yet..'),
                  )
                : ListView.builder(
                    itemCount: filteredExpanses.length,
                    itemBuilder: (context, index) {
                      final expanse = filteredExpanses[index];
                      return ListTile(
                        title: Text(expanse.title),
                        subtitle: Text(
                            "${expanse.amount} so'm  ${expanse.date.day}/${expanse.date.month}/${expanse.date.year}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showExpanseDialog(context, ref,
                                      isEdit: true, expanse: expanse);
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  ref
                                      .read(expanseProvider.notifier)
                                      .deleteExpanse(expanse.id);
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                      );
                    }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showExpanseDialog(
          context,
          ref,
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  void showExpanseDialog(BuildContext context, WidgetRef ref,
      {bool isEdit = false, ExpanseModel? expanse}) {
    final titleController = TextEditingController(text: expanse?.title);
    final amountController = TextEditingController(
      text: expanse?.amount.toString(),
    );

    showDialog(
      context: context,
      builder: (context) =>ExpanseDialog(
        isEdit: isEdit,
        expanse: expanse ?? ExpanseModel(
          id: Uuid().v4(),
          title: titleController.text.trim(),
          amount:  double.tryParse(amountController.text.trim()) ?? 0.0,
          date: DateTime.now(), 
      
        ),
        titleController: titleController,
        amountController: amountController,
        ref: ref,
      ),
    );
  }
}
