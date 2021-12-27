import 'package:flutter/material.dart';
import 'package:practice_flutter_ddd/application/dto/category_dto.dart';
import 'package:provider/provider.dart';
import 'package:practice_flutter_ddd/presentation/notifier/note_notifier.dart';
import 'package:practice_flutter_ddd/presentation/widget/note/edit_dialog.dart';

class NoteAddButton extends StatelessWidget {
  final CategoryDto category;

  const NoteAddButton({required this.category});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => NoteEditDialog(
        context: context,
        heading: 'New note',
        buttonLabel: 'SAVE',
        category: category,
        onSave: ({String? title, String? body, String? categoryId}) async {
          await context.read<NoteNotifier>().saveNote(
                title: title,
                body: body,
                categoryId: category.id,
              );
        },
      ).show(),
    );
  }
}
