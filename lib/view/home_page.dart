import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/controller/expanse_provider.dart';
import 'package:tracker/models/expanse_model.dart';
import 'package:uuid/uuid.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanses = ref.watch(expanseProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Expanse Tracker"),
      ),
      body: expanses.isEmpty
          ? const Center(
              child: Text('No expanses yet..'),
            )
          : ListView.builder(
            itemCount: expanses.length,
            itemBuilder: (context, index) {
              final expanse = expanses[index];
              return ListTile(
                title: Text(expanse.title),
                subtitle: Text("${expanse.amount} so'm "),
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
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Expanse" : "Add Expanse"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: "Amount"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            onPressed: () {
              final title = titleController.text.trim();
              final amount =
                  double.tryParse(amountController.text.trim()) ?? 0.0;
              if (title.isEmpty || amount <= 0) return;

              final newExpanse = ExpanseModel(
                  id: isEdit ? expanse!.id : Uuid().v4(),
                  title: title,
                  amount: amount,
                  date: DateTime.now());
              if (isEdit) {
                ref.read(expanseProvider.notifier).updateExpanse(newExpanse);
              } else {
                ref.read(expanseProvider.notifier).addExpanse(newExpanse);
              }
              Navigator.pop(context);
            },
            child: Text(isEdit ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }
}
