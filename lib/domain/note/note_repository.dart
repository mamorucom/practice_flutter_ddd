import 'package:practice_flutter_ddd/domain/category/value/category_id.dart';
import 'package:practice_flutter_ddd/domain/note/note.dart';
import 'package:practice_flutter_ddd/infrastructure/db_helper.dart';

import 'value/note_body.dart';
import 'value/note_id.dart';
import 'value/note_title.dart';

export 'package:practice_flutter_ddd/domain/note/note.dart';

abstract class NoteRepositoryBase {
  Future<T> transaction<T>(Future<T> Function() f);
  Future<Note?> find(NoteId id);
  Future<Note?> findByTitle(NoteTitle title);
  Future<List<Note>> findByCategory(CategoryId categoryId);
  Future<int?> countByCategory(CategoryId categoryId);
  Future<void> save(Note note);
  Future<void> remove(Note note);
}

class NoteRepository implements NoteRepositoryBase {
  final DbHelper _dbHelper;

  const NoteRepository({required DbHelper dbHelper}) : _dbHelper = dbHelper;

  ///
  /// カテゴリオブジェクトに変換
  ///
  Note toNote(Map<String, dynamic> data) {
    final id = data['id'].toString();
    final title = data['title'].toString();
    final body = data['body'].toString();
    final categoryId = data['category'].toString();

    return Note(
      id: NoteId(id),
      title: NoteTitle(title),
      body: NoteBody(body),
      categoryId: CategoryId(categoryId),
      // categoryId: categoryId == null || categoryId.isEmpty
      //     ? null
      //     : CategoryId(categoryId),
    );
  }

  @override
  Future<T> transaction<T>(Future<T> Function() f) async {
    return await _dbHelper.transaction<T>(() async => await f());
  }

  @override
  Future<Note?> find(NoteId id) async {
    final list = await _dbHelper.rawQuery(
      'SELECT * FROM notes WHERE id = ?',
      <String>[id.value],
    );

    return list.isEmpty ? null : toNote(list[0]);
  }

  @override
  Future<Note?> findByTitle(NoteTitle title) async {
    final list = await _dbHelper.rawQuery(
      'SELECT * FROM notes WHERE title = ?',
      <String>[title.value],
    );

    // 検索してもなければnull, あればmap->ノートオブジェクトに変換して返す.
    return list.isEmpty ? null : toNote(list[0]);
  }

  @override
  Future<List<Note>> findByCategory(CategoryId categoryId) async {
    final list = await _dbHelper.rawQuery(
      'SELECT * FROM notes WHERE category_id = ?',
      <String>[categoryId.value],
    );

    // 検索してもなければnull, あればmap->ノートオブジェクトに変換して返す.
    return list.isEmpty ? <Note>[] : list.map((data) => toNote(data)).toList();
  }

  ///
  /// カテゴリカウント
  ///
  @override
  Future<int?> countByCategory(CategoryId categoryId) async {
    final list = await _dbHelper.rawQuery(
      'SELECT COUNT(*) AS cnt FROM notes WHERE category_id = ?',
      <String>[categoryId.value],
    );

    final row = Map<String, int>.from(list[0]);
    return row['cnt'];
  }

  ///
  /// 新規挿入（追加）または置換（更新）
  ///
  @override
  Future<void> save(Note note) async {
    await _dbHelper.rawInsert(
      '''
        INSERT OR REPLACE INTO notes
        (id, title, body, category_id) VALUES (?, ?, ?, ?)
      ''',
      <String>[
        note.id.value,
        note.title.value,
        note.body.value,
        note.categoryId.value,
      ],
    );
  }

  @override
  Future<void> remove(Note note) async {
    await _dbHelper.rawDelete(
      'DELETE FROM notes WHERE id = ?',
      <String>[note.id.value],
    );
  }
}
