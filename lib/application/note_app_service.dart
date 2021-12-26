import 'package:meta/meta.dart';
import 'package:practice_flutter_ddd/common/exception.dart';
// import 'package:practice_flutter_ddd/domain/note/note_factory.dart';
// import 'package:practice_flutter_ddd/domain/note/note_repository.dart';
// import 'package:practice_flutter_ddd/domain/note/note_service.dart';
import 'package:practice_flutter_ddd/domain/note/value/note_id.dart';

import 'dto/note_dto.dart';
// import 'package:practice_flutter_ddd/domain/note/note_repository.dart';
export 'package:practice_flutter_ddd/application/dto/note_dto.dart';

/// ユースケース図に書いた「ユーザとアプリケーションの相互作用」を実装して業務の問題を解決する（ユースケースを満たす）部分がアプリケーションサービスだと思います。
/// 基本的にドメイン層に用意したものを使うだけです。 例えば下記はカテゴリを登録するメソッドで、カテゴリのエンティティを生成するファクトリ、名前の重複を確認するドメインサービスのメソッド、DB に保存するリポジトリのメソッド、といった用意済みのものを組み合わせています。

@immutable
class NoteAppService {
  // NoteAppService({
  //   required NoteFactoryBase factory,
  //   required NoteRepositoryBase repository,
  // })  : _factory = factory,
  //       _repository = repository,
  //       _service = NoteService(repository: repository);

  // final NoteFactoryBase _factory;
  // final NoteRepositoryBase _repository;
  // final NoteService _service;

  // ///
  // /// カテゴリを登録する
  // ///
  // Future<void> saveNote({required String name}) async {
  //   // まずはカテゴリオブジェクトを生成
  //   final note = _factory.create(name: name);

  //   /// 登録する
  //   /// -> DBのトランザクション処理 - 引数の無名関数以下を実行する.
  //   /// 実行失敗でthrow
  //   await _repository.transaction(() async {
  //     if (await _service.isDuplicated(note.name)) {
  //       throw NotUniqueException(
  //         code: ExceptionCode.noteName,
  //         value: note.name.value,
  //       );
  //     } else {
  //       await _repository.save(note);
  //     }
  //   });
  // }

  // ///
  // /// カテゴリを更新する
  // ///
  // Future<void> updateNote({
  //   required String id,
  //   required String name,
  // }) async {
  //   // 値オブジェクト生成
  //   final targetId = NoteId(id);

  //   await _repository.transaction(() async {
  //     // 検索
  //     final targetNote = await _repository.find(targetId);
  //     if (targetNote == null) {
  //       throw NotFoundException(
  //         code: ExceptionCode.noteName,
  //         target: targetId.value,
  //       );
  //     }

  //     // 変更
  //     final newName = NoteName(name);
  //     // 他のカテゴリとの重複チェック
  //     if (newName != targetNote.name && await _service.isDuplicated(newName)) {
  //       throw NotUniqueException(
  //         code: ExceptionCode.noteName,
  //         value: newName.value,
  //       );
  //     }
  //     targetNote.changeName(newName);

  //     // 保存
  //     await _repository.save(targetNote);
  //   });
  // }

  // ///
  // /// カテゴリを削除する
  // ///
  // Future<void> removeNote({
  //   required String id,
  // }) async {
  //   // 値オブジェクト生成
  //   final targetId = NoteId(id);

  //   await _repository.transaction(() async {
  //     // 検索
  //     final targetNote = await _repository.find(targetId);
  //     if (targetNote == null) {
  //       throw NotFoundException(
  //         code: ExceptionCode.noteName,
  //         target: targetId.value,
  //       );
  //     }

  //     // TODO: メモがあればエラー

  //     // 削除
  //     await _repository.remove(targetNote);
  //   });
  // }

  // ///
  // /// カテゴリ一覧を取得
  // ///
  // Future<List<NoteDto>> getNoteList() async {
  //   final categories = await _repository.findAll();
  //   return categories.map((x) => NoteDto(x)).toList();
  // }
}
