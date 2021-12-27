import 'package:meta/meta.dart';
import 'package:practice_flutter_ddd/common/exception.dart';
import 'package:practice_flutter_ddd/domain/category/value/category_id.dart';
import 'package:practice_flutter_ddd/domain/note/note_factory.dart';
import 'package:practice_flutter_ddd/domain/note/note_repository.dart';
import 'package:practice_flutter_ddd/domain/note/note_service.dart';
import 'package:practice_flutter_ddd/domain/note/value/note_body.dart';
import 'package:practice_flutter_ddd/domain/note/value/note_id.dart';
import 'package:practice_flutter_ddd/domain/note/value/note_title.dart';

import 'dto/note_dto.dart';
import 'dto/note_summary_dto.dart';
// import 'package:practice_flutter_ddd/domain/note/note_repository.dart';
export 'package:practice_flutter_ddd/application/dto/note_dto.dart';

/// ユースケース図に書いた「ユーザとアプリケーションの相互作用」を実装して業務の問題を解決する（ユースケースを満たす）部分がアプリケーションサービスだと思います。
/// 基本的にドメイン層に用意したものを使うだけです。 例えば下記はカテゴリを登録するメソッドで、カテゴリのエンティティを生成するファクトリ、名前の重複を確認するドメインサービスのメソッド、DB に保存するリポジトリのメソッド、といった用意済みのものを組み合わせています。

@immutable
class NoteAppService {
  NoteAppService({
    required NoteFactoryBase factory,
    required NoteRepositoryBase repository,
  })  : _factory = factory,
        _repository = repository,
        _service = NoteService(repository: repository);

  final NoteFactoryBase _factory;
  final NoteRepositoryBase _repository;
  final NoteService _service;

  ///
  /// メモを登録する
  ///
  Future<void> saveNote({
    required String title,
    required String body,
    required String categoryId,
  }) async {
    // まずはカテゴリオブジェクトを生成
    final note =
        _factory.create(title: title, body: body, categoryId: categoryId);

    /// 登録する
    /// -> DBのトランザクション処理 - 引数の無名関数以下を実行する.
    /// 実行失敗でthrow
    await _repository.transaction(() async {
      if (await _service.isDuplicated(note.title)) {
        throw NotUniqueException(
          code: ExceptionCode.noteTitle,
          value: note.title.value,
        );
      } else {
        await _repository.save(note);
      }
    });
  }

  ///
  /// メモを更新する
  ///
  Future<void> updateNote({
    required String id,
    required String title,
    required String body,
    required String categoryId,
  }) async {
    // 値オブジェクト生成
    final targetId = NoteId(id);

    await _repository.transaction(() async {
      // 検索
      final targetNote = await _repository.find(targetId);
      if (targetNote == null) {
        throw NotFoundException(
          code: ExceptionCode.noteId,
          target: targetId.value,
        );
      }

      // 変更
      final newTitle = NoteTitle(title);
      // 他のカテゴリとの重複チェック
      if (newTitle != targetNote.title &&
          await _service.isDuplicated(newTitle)) {
        throw NotUniqueException(
          code: ExceptionCode.noteTitle,
          value: newTitle.value,
        );
      }
      targetNote.changeTitle(newTitle);

      final newBody = NoteBody(body);
      targetNote.changeBody(newBody);

      final newCategoryId = CategoryId(categoryId);
      targetNote.changeCategory(newCategoryId);

      // 保存
      await _repository.save(targetNote);
    });
  }

  ///
  /// カテゴリを削除する
  ///
  Future<void> removeNote({
    required String id,
  }) async {
    // 値オブジェクト生成
    final targetId = NoteId(id);

    await _repository.transaction(() async {
      // 検索
      final targetNote = await _repository.find(targetId);
      if (targetNote == null) {
        throw NotFoundException(
          code: ExceptionCode.noteId,
          target: targetId.value,
        );
      }

      // 削除
      await _repository.remove(targetNote);
    });
  }

  ///
  /// 該当のメモを取得
  ///
  Future<NoteDto?> getNote(String id) async {
    final targetId = NoteId(id);
    final target = await _repository.find(targetId);

    return target == null ? null : NoteDto(target);
  }

  ///
  /// メモ一覧を取得
  ///
  Future<List<NoteSummaryDto>> getNoteList(String categoryId) async {
    final targetId = CategoryId(categoryId);
    final notes = await _repository.findByCategory(targetId);

    return notes.map((x) => NoteSummaryDto(x)).toList();
  }
}
