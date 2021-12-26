import 'package:flutter/foundation.dart';
import 'package:practice_flutter_ddd/application/dto/note_dto.dart';
import 'package:practice_flutter_ddd/application/note_app_service.dart';

class NoteNotifier with ChangeNotifier {
  NoteNotifier({required NoteAppService app}) : _app = app {
    _updateList();
  }
  final NoteAppService _app;

  List<NoteDto> _list = [];

  List<NoteDto>? get list => _list == null ? null : List.unmodifiable(_list);

  ///
  /// リストの更新イベント
  ///
  void _updateList() {
    // _app.getNoteList().then((list) {
    //   _list = list;
    //   notifyListeners();
    // });
  }
}
