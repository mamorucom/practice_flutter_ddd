import 'package:flutter/foundation.dart';
import 'package:practice_flutter_ddd/application/dto/note_summary_dto.dart';
import 'package:practice_flutter_ddd/application/note_app_service.dart';

class NoteNotifier with ChangeNotifier {
  NoteNotifier({required NoteAppService app, required String categoryId})
      : _app = app,
        _categoryId = categoryId {
    _updateList();
  }
  final NoteAppService _app;
  final String _categoryId;

  List<NoteSummaryDto> _list = [];

  List<NoteSummaryDto>? get list =>
      _list == null ? null : List.unmodifiable(_list);

  ///
  /// メモ保存イベント
  ///
  Future<void> saveNote({
    required String title,
    required String body,
    required String categoryId,
  }) async {
    await _app.saveNote(title: title, body: body, categoryId: categoryId);
    _updateList();
  }

  ///
  /// メモ更新イベント
  ///
  Future<void> updateNote({
    required String id,
    required String title,
    required String body,
    required String categoryId,
  }) async {
    await _app.updateNote(
      id: id,
      title: title,
      body: body,
      categoryId: categoryId,
    );
    _updateList();
  }

  ///
  /// メモ削除イベント
  ///
  Future<void> removeNote(String noteId) async {
    await _app.removeNote(id: noteId);
    _updateList();
  }

  ///
  /// メモ取得イベント
  ///
  Future<NoteDto?> getNote(String noteId) async {
    final note = await _app.getNote(noteId);
    return note;
  }

  ///
  /// リストの更新イベント
  ///
  void _updateList() {
    _app.getNoteList(_categoryId).then((list) {
      _list = list;
      notifyListeners();
    });
  }
}
