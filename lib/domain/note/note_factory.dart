import 'package:practice_flutter_ddd/domain/category/value/category_id.dart';
import 'package:practice_flutter_ddd/domain/note/note.dart';
import 'package:uuid/uuid.dart';

import 'value/note_body.dart';
import 'value/note_id.dart';
import 'value/note_title.dart';

export 'package:practice_flutter_ddd/domain/note/note.dart';

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
abstract class NoteFactoryBase {
  Note create({
    required String title,
    required String body,
    required String categoryId,
  });
}

class NoteFactory implements NoteFactoryBase {
  @override
  Note create({
    required String title,
    required String body,
    required String categoryId,
  }) {
    return Note(
      id: NoteId(const Uuid().v4()),
      title: NoteTitle(title),
      body: NoteBody(body),
      categoryId: CategoryId(categoryId),
    );
  }
}
