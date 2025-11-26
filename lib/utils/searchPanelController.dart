import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/searchPanel.dart';

class SearchPanelController {
  static void show(
      BuildContext context, {
        required List<String> suggestions,
        required Function(String) onSelected,
      }) => Scaffold(
    body: SearchPanel(
      suggestions: suggestions,
      onSelected: onSelected,
    ),
  );
}
