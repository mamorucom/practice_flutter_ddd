import 'package:practice_flutter_ddd/domain/category/category.dart';
import 'package:practice_flutter_ddd/infrastructure/db_helper.dart';

import 'value/category_id.dart';
import 'value/category_name.dart';

export 'package:practice_flutter_ddd/domain/category/category.dart';

abstract class CategoryRepositoryBase {
  Future<T> transaction<T>(Future<T> Function() f);
  Future<Category?> find(CategoryId id);
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
  Future<T> transaction<T>(Future<T> Function() f) async {
    return await _dbHelper.transaction<T>(() async => await f());
  }

  @override
  Future<Category?> find(CategoryId id) async {
    final list = await _dbHelper.rawQuery(
      'SELECT * FROM categories WHERE id = ?',
      <String>[id.value],
    );

    return list.isEmpty ? null : toCategory(list[0]);
  }

  @override
  Future<Category?> findByName(CategoryName name) async {
    final list = await _dbHelper.rawQuery(
      'SELECT * FROM categories WHERE name = ?',
      <String>[name.value],
    );

    // 検索してもなければnull, あればmap->カテゴリーオブジェクトに変換して返す.
    return list.isEmpty ? null : toCategory(list[0]);
  }

  @override
  Future<List<Category>> findAll() async {
    final list = await _dbHelper.rawQuery(
      'SELECT * FROM categories ORDER BY name',
    );

    // 検索してもなければnull,
    // あればlist->map->ひとつずつカテゴリーオブジェクトに変換してList形式で返す.
    return list.isEmpty
        ? <Category>[]
        : list.map((data) => toCategory(data)).toList();
  }

  ///
  /// 新規挿入（追加）または置換（更新）
  ///
  @override
  Future<void> save(Category category) async {
    await _dbHelper.rawInsert(
      'INSERT OR REPLACE INTO categories (id, name) VALUES (?, ?)',
      <String>[category.id.value, category.name.value],
    );
  }

  @override
  Future<void> remove(Category category) async {
    await _dbHelper.rawDelete(
      'DELETE FROM categories WHERE id = ?',
      <String>[category.id.value],
    );
  }
}
