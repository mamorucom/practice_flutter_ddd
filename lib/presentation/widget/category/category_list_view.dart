import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice_flutter_ddd/presentation/notifier/category_notifier.dart';
import 'package:practice_flutter_ddd/presentation/page/note_list.dart';
import 'package:practice_flutter_ddd/presentation/widget/category/edit_button.dart';
import 'package:practice_flutter_ddd/presentation/widget/category/remove_button.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView();

  @override
  Widget build(BuildContext context) {
    // final list = context.select((CategoryNotifier notifier) => notifier.list);

    // if (list == null)
    //   return const Center(child: CircularProgressIndicator());
    // else if (list.isEmpty)
    //   return const Center(
    //     child: Text(
    //       'No category yet',
    //       style: TextStyle(color: Colors.grey),
    //     ),
    //   );
    // return ListView.builder(
    //   itemCount: list.length,
    //   itemBuilder: (context, index) => _listTile(context, list[index]),
    // );
    return Container();
  }
}