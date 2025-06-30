// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onClear;
  final Function(String) onSearchTypeChanged;
  final String searchType;

  const CustomSearchBar({
    super.key,
    required this.onSearch,
    required this.onClear,
    required this.onSearchTypeChanged,
    required this.searchType,
  });

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  bool _showClear = false;

  final List<DropdownMenuItem<String>> _searchTypes = [
    const DropdownMenuItem(value: 'title', child: Text('Search by Title')),
    const DropdownMenuItem(value: 'author', child: Text('Search by Author')),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _showClear = _controller.text.isNotEmpty;
    });

    // Debounce the search
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_controller.text.isNotEmpty) {
        widget.onSearch(_controller.text);
      }
    });
  }

  void _onClear() {
    _controller.clear();
    widget.onClear();
  }

  String _getPlaceholderText(String searchType) {
    switch (searchType) {
      case 'author':
        return 'Search by author name...';
      default:
        return 'Search by book title...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: _getPlaceholderText(widget.searchType),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_showClear)
                IconButton(icon: const Icon(Icons.clear), onPressed: _onClear),
              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Select search type',
                onSelected: (String value) {
                  widget.onSearchTypeChanged(value);
                  if (_controller.text.isNotEmpty) {
                    widget.onSearch(_controller.text);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return _searchTypes.map((DropdownMenuItem<String> item) {
                    return PopupMenuItem<String>(
                      value: item.value,
                      child: Row(
                        children: [
                          if (widget.searchType == item.value)
                            const Icon(Icons.check, size: 18)
                          else
                            const SizedBox(width: 18),
                          const SizedBox(width: 8),
                          item.child,
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
