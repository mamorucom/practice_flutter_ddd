import 'package:flutter/foundation.dart';
import 'package:practice_flutter_ddd/application/category_app_service.dart';

export 'package:practice_flutter_ddd/application/dto/category_dto.dart';

class CategoryNotifier with ChangeNotifier {
  CategoryNotifier({required CategoryAppService app}) : _app = app {
    _updateList();
  }

  final CategoryAppService _app;

  List<CategoryDto> _list = [];

  List<CategoryDto>? get list =>
      _list == null ? null : List.unmodifiable(_list);

  ///
  /// カテゴリ保存イベント
  ///
  Future<void> saveCategory({required String name}) async {
    await _app.saveCategory(name: name);
    _updateList();
  }

  ///
  /// カテゴリ名更新イベント
  ///
  Future<void> updateCategory({required String id, String? name}) async {
    await _app.updateCategory(id: id, name: name ?? '');
    _updateList();
  }

  ///
  /// カテゴリ削除イベント
  ///
  Future<void> removeCategory(String categoryId) async {
    await _app.removeCategory(id: categoryId);
    _updateList();
  }

  ///
  /// リストの更新イベント
  ///
  void _updateList() {
    _app.getCategoryList().then((list) {
      _list = list;
      notifyListeners();
    });
  }
}
