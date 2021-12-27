import 'package:flutter/material.dart';
import 'package:practice_flutter_ddd/presentation/widget/note/remove_dialog.dart';

class NoteRemoveButton extends StatelessWidget {
  final String noteId;

  const NoteRemoveButton({required this.noteId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () => NoteRemoveDialog(
        context: context,
        noteId: noteId,
      ).show(),
    );
  }
}
