import 'package:meta/meta.dart';
import 'package:practice_flutter_ddd/common/exception.dart';
import 'package:practice_flutter_ddd/domain/category/category_factory.dart';
import 'package:practice_flutter_ddd/domain/category/category_repository.dart';
import 'package:practice_flutter_ddd/domain/category/category_service.dart';
import 'package:practice_flutter_ddd/domain/category/value/category_id.dart';
import 'package:practice_flutter_ddd/domain/category/value/category_name.dart';
import 'package:practice_flutter_ddd/domain/note/note_repository.dart';

import 'dto/category_dto.dart';

export 'package:practice_flutter_ddd/application/dto/category_dto.dart';

/// ユースケース図に書いた「ユーザとアプリケーションの相互作用」を実装して業務の問題を解決する（ユースケースを満たす）部分がアプリケーションサービスだと思います。
/// 基本的にドメイン層に用意したものを使うだけです。 例えば下記はカテゴリを登録するメソッドで、カテゴリのエンティティを生成するファクトリ、名前の重複を確認するドメインサービスのメソッド、DB に保存するリポジトリのメソッド、といった用意済みのものを組み合わせています。

@immutable
class CategoryAppService {
  // const CategoryAppService({required this.factory});

  CategoryAppService({
    required CategoryFactoryBase factory,
    required CategoryRepositoryBase repository,
    required NoteRepositoryBase noteRepository,
  })  : _factory = factory,
        _repository = repository,
        _service = CategoryService(repository: repository),
        _noteRepository = noteRepository;

  final CategoryFactoryBase _factory;
  final CategoryRepositoryBase _repository;
  final CategoryService _service;
  final NoteRepositoryBase _noteRepository;

  ///
  /// カテゴリを登録する
  ///
  Future<void> saveCategory({required String name}) async {
    // まずはカテゴリオブジェクトを生成
    final category = _factory.create(name: name);

    /// 登録する
    /// -> DBのトランザクション処理 - 引数の無名関数以下を実行する.
    /// 実行失敗でthrow
    await _repository.transaction(() async {
      if (await _service.isDuplicated(category.name)) {
        throw NotUniqueException(
          code: ExceptionCode.categoryName,
          value: category.name.value,
        );
      } else {
        await _repository.save(category);
      }
    });
  }

  ///
  /// カテゴリを更新する
  ///
  Future<void> updateCategory({
    required String id,
    required String name,
  }) async {
    // 値オブジェクト生成
    final targetId = CategoryId(id);

    await _repository.transaction(() async {
      // 検索
      final targetCategory = await _repository.find(targetId);
      if (targetCategory == null) {
        throw NotFoundException(
          code: ExceptionCode.categoryName,
          target: targetId.value,
        );
      }

      // 変更
      final newName = CategoryName(name);
      // 他のカテゴリとの重複チェック
      if (newName != targetCategory.name &&
          await _service.isDuplicated(newName)) {
        throw NotUniqueException(
          code: ExceptionCode.categoryName,
          value: newName.value,
        );
      }
      targetCategory.changeName(newName);

      // 保存
      await _repository.save(targetCategory);
    });
  }

  ///
  /// カテゴリを削除する
  ///
  Future<void> removeCategory({
    required String id,
  }) async {
    // 値オブジェクト生成
    final targetId = CategoryId(id);

    await _repository.transaction(() async {
      // 検索
      final targetCategory = await _repository.find(targetId);
      if (targetCategory == null) {
        throw NotFoundException(
          code: ExceptionCode.categoryName,
          target: targetId.value,
        );
      }

      // メモがあればエラー
      final countByCategory =
          await _noteRepository.countByCategory(targetId) ?? 0;
      if (countByCategory > 0) {
        throw RemovalException(code: ExceptionCode.category);
      }

      // 削除
      await _repository.remove(targetCategory);
    });
  }

  ///
  /// カテゴリ一覧を取得
  ///
  Future<List<CategoryDto>> getCategoryList() async {
    final categories = await _repository.findAll();
    return categories.map((x) => CategoryDto(x)).toList();
  }
}
