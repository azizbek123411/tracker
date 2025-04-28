import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/repo/models/expanse_model.dart';
import 'package:uuid/uuid.dart';

import '../../controller/provider/expanse_provider.dart';

class ExpanseDialog extends StatelessWidget {
  final bool isEdit;
  final ExpanseModel expanse;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final WidgetRef ref;
  const ExpanseDialog({
    super.key,
    required this.isEdit,
    required this.expanse,
    required this.titleController,
    required this.amountController,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
            if (title.isEmpty || amount <= 0) return;

            final newExpanse = ExpanseModel(
                id: isEdit ? expanse.id : Uuid().v4(),
                title: title,
                amount: amount,
                date: DateTime.now(),  
                );
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
    );
  }
}
