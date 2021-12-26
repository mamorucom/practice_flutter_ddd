import 'package:practice_flutter_ddd/domain/category/category.dart';
import 'package:practice_flutter_ddd/infrastructure/db_helper.dart';

import 'value/category_id.dart';
import 'value/category_name.dart';

export 'package:practice_flutter_ddd/domain/category/category.dart';

abstract class CategoryRepositoryBase {
  Future<T> transaction<T>(Future<T> Function() f);
  Future<Category> find(CategoryId id);
  Future<Category?> findByName(CategoryName name);
  Future<List<Category>> findAll();
  Future<void> save(Category category);
  Future<void> remove(Category category);
}

class CategoryRepository implements CategoryRepositoryBase {
  final DbHelper _dbHelper;

  const CategoryRepository({required DbHelper dbHelper}) : _dbHelper = dbHelper;

  ///
  /// カテゴリオブジェクトに変換
  ///
  Category toCategory(Map<String, dynamic> data) {
    final id = data['id'].toString();
    final name = data['name'].toString();

    return Category(
      id: CategoryId(id),
      name: CategoryName(name),
    );
  }

  @override
  Future<T> transaction<T>(Future<T> Function() f) {
    // TODO: implement transaction
    throw UnimplementedError();
  }

  @override
  Future<Category> find(CategoryId id) {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  Future<Category?> findByName(CategoryName name) async {
    final list = await _dbHelper.rawQuery(
      'SELECT * FROM categories WHERE name = ?',
      <String>[name.value],
    );

    //検索してもなければnull, あればmap->カテゴリーオブジェクトに変換して返す.
    return list.isEmpty ? null : toCategory(list[0]);
  }

  @override
  Future<List<Category>> findAll() {
    // TODO: implement findAll
    throw UnimplementedError();
  }

  @override
  Future<void> save(Category category) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> remove(Category category) {
    // TODO: implement remove
    throw UnimplementedError();
  }
}
