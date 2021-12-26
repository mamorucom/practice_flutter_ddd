import 'package:meta/meta.dart';
import 'package:practice_flutter_ddd/domain/category/category.dart';
import 'package:uuid/uuid.dart';

import 'value/category_id.dart';
import 'value/category_name.dart';

export 'package:practice_flutter_ddd/domain/category/category.dart';

///
/// カテゴリーオブジェクトを生成するためのファクトリクラス
/// - メモアプリであれば、メモを作る処理をメモ自体に持たせずにメモ工場に委譲するということです。
/// この他に、生成処理が分離されてテストしやすくなる効果もあります。
/// 例えば ID を DB で自動採番するアプリであっても、テストでは DB を使わない採番方法に差し替えやすくなります。
/// そのためファクトリもリポジトリのように、ドメイン層にインタフェース（抽象クラス）、
/// インフラ層に実装を置いています（が、メモアプリでは環境に依存しない Uuid() を採番に使っていてテストでも使い回せるので、テスト専用の実装はしていません）。
///
/// ➡ 抽象クラスの実装がばらけると、コードが追いづらくて気が狂いそうなのでこのファイルにimplementsする
///
abstract class CategoryFactoryBase {
  Category create({required String name});
}

class CategoryFactory implements CategoryFactoryBase {
  @override
  Category create({required String name}) {
    return Category(
      id: CategoryId(const Uuid().v4()),
      name: CategoryName(name),
    );
  }
}
