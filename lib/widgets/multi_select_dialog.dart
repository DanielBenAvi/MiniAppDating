import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:social_hive_client/model/item_object.dart';

class MultiSelect extends StatelessWidget {
  MultiSelect(this.title, this.buttonText, this.itemsList,
      {super.key, required this.onMultiSelectConfirm}) {
    items = itemsList
        .map((item) => MultiSelectItem<ItemObject>(item, item.name))
        .toList();
  }

  String title;
  String buttonText;
  List<ItemObject> itemsList;
  late List<MultiSelectItem<ItemObject>> items;

  final MultiSelectCallback onMultiSelectConfirm;

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      searchable: true,
      items: items,
      title: Text(title),
      selectedColor: Colors.pink,
      listType: MultiSelectListType.LIST,
      selectedItemsTextStyle: const TextStyle(
        color: Colors.pink,
      ),
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.1),
        border: Border.all(
          color: Colors.pink,
          width: 2,
        ),
      ),
      buttonIcon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.pink,
      ),
      buttonText: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.pink,
          fontSize: 16,
        ),
      ),
      onConfirm: (results) {
        onMultiSelectConfirm(results);
      },
    );
  }
}

typedef MultiSelectCallback = void Function(List<ItemObject> results);
