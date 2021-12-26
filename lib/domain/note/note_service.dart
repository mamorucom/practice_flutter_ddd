import 'package:meta/meta.dart';
import 'package:practice_flutter_ddd/domain/note/note_repository.dart';

import 'value/note_title.dart';

class NoteService {
  final NoteRepositoryBase _repository;

  const NoteService({required NoteRepositoryBase repository})
      : _repository = repository;

  ///
  /// カテゴリー重複チェック
  ///
  Future<bool> isDuplicated(NoteTitle title) async {
    final searched = await _repository.findByTitle(title);
    // 同じカテゴリー名があればtrueを返す.
    return searched != null;
  }
}
