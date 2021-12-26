import 'package:meta/meta.dart';
import 'package:practice_flutter_ddd/domain/category/category_repository.dart';

import 'value/category_name.dart';

class CategoryService {
  final CategoryRepositoryBase _repository;

  const CategoryService({required CategoryRepositoryBase repository})
      : _repository = repository;

  ///
  /// カテゴリー重複チェック
  ///
  Future<bool> isDuplicated(CategoryName name) async {
    final searched = await _repository.findByName(name);
    // 同じカテゴリー名があればtrueを返す.
    return searched != null;
  }
}
