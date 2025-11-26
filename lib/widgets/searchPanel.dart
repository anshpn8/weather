import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:standard_searchbar/new/standard_search_anchor.dart';
import 'package:standard_searchbar/new/standard_search_bar.dart';
import 'package:standard_searchbar/new/standard_suggestion.dart';
import 'package:standard_searchbar/new/standard_suggestions.dart';

class SearchPanel extends StatefulWidget{
  List<String> suggestions;
  final Function(String) onSelected;
  SearchPanel({super.key, required this.suggestions, required this.onSelected});


  @override
  State<SearchPanel> createState() => _SearchPanelState();

}

class _SearchPanelState extends State<SearchPanel> {


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StandardSearchAnchor(
      searchBar: StandardSearchBar(
        bgColor: Colors.red,
      ),
      suggestions: StandardSuggestions(
        suggestions: List.generate(widget.suggestions.length, (index)=>
          StandardSuggestion(text: widget.suggestions[index]),
        ),
      ),
    );
  }
}