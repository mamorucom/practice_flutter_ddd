import 'package:meta/meta.dart';
import 'package:practice_flutter_ddd/common/exception.dart';
import 'package:practice_flutter_ddd/domain/category/category_factory.dart';
import 'package:practice_flutter_ddd/domain/category/category_repository.dart';
// import 'package:practice_flutter_ddd/domain/category/category_repository_base.dart';
import 'package:practice_flutter_ddd/domain/category/category_service.dart';

import 'dto/category_dto.dart';
// import 'package:practice_flutter_ddd/domain/note/note_repository_base.dart';
// import 'package:practice_flutter_ddd/application/dto/category_dto.dart';

export 'package:practice_flutter_ddd/application/dto/category_dto.dart';

/// ユースケース図に書いた「ユーザとアプリケーションの相互作用」を実装して業務の問題を解決する（ユースケースを満たす）部分がアプリケーションサービスだと思います。
/// 基本的にドメイン層に用意したものを使うだけです。 例えば下記はカテゴリを登録するメソッドで、カテゴリのエンティティを生成するファクトリ、名前の重複を確認するドメインサービスのメソッド、DB に保存するリポジトリのメソッド、といった用意済みのものを組み合わせています。

@immutable
class CategoryAppService {
  // const CategoryAppService({required this.factory});

  CategoryAppService({
    required CategoryFactoryBase factory,
    required CategoryRepositoryBase repository,
  })  : _factory = factory,
        _repository = repository,
        _service = CategoryService(repository: repository);

  final CategoryFactoryBase _factory;
  final CategoryRepositoryBase _repository;
  final CategoryService _service;

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

  ///
  /// カテゴリを削除する
  ///

  ///
  /// カテゴリの一覧を削除する
  ///

  ///
  /// カテゴリ一覧を取得
  ///
  Future<List<CategoryDto>> getCategoryList() async {
    final categories = await _repository.findAll();
    return categories.map((x) => CategoryDto(x)).toList();
  }
}
