import 'package:flutter/material.dart';
import 'package:practice_flutter_ddd/presentation/widget/note/edit_dialog.dart';

class CategoryDropdown extends StatefulWidget {
  final List<CategoryDto> list;
  final CategoryDto value;
  final Function(CategoryDto) onChanged;

  const CategoryDropdown({
    required this.list,
    required this.value,
    required this.onChanged,
  });

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  late CategoryDto _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Category',
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CategoryDto>(
          isExpanded: true,
          isDense: true,
          value: _value,
          items: widget.list
              .map(
                (category) => DropdownMenuItem<CategoryDto>(
                  value: category,
                  child: Text(category.name),
                ),
              )
              .toList(),
          onChanged: (category) {
            setState(() => _value = category!);
            widget.onChanged(category!);
          },
        ),
      ),
    );
  }
}
