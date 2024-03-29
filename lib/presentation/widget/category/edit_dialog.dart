import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice_flutter_ddd/common/exception.dart';
import 'package:practice_flutter_ddd/presentation/widget/error_dialog.dart';

typedef SaveCallback = Future<void> Function({required String name});

class CategoryEditDialog extends StatelessWidget {
  final BuildContext _context;
  final String heading;
  final String buttonLabel;
  final SaveCallback onSave;
  final TextEditingController _nameController;

  CategoryEditDialog({
    Key? key,
    required BuildContext context,
    required this.heading,
    required this.buttonLabel,
    required this.onSave,
    String? initialName,
  })  : _context = context,
        _nameController = context.read<TextEditingController>()
          ..text = initialName ?? '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Text(heading),
          content: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter category name',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(buttonLabel),
              onPressed: () async => _onPressed(context),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// ダイアログ表示
  /// (こんなことできるのか...)
  ///
  void show() {
    showDialog<void>(
      context: _context,
      builder: build,
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    try {
      await onSave(name: _nameController.text);
      Navigator.of(context).pop();
    } on GenericException catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog(e.message);
    } catch (_) {
      Navigator.of(context).pop();
      _showErrorDialog('Unknown error occurred.');
    }
  }

  void _showErrorDialog(String message) {
    ErrorDialog(
      context: _context,
      message: message,
      onConfirm: show,
    ).show();
  }
}
