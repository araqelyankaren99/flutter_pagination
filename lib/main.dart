import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pagination/empty_list_widget.dart';
import 'package:flutter_pagination/pagination_widget.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();

  final List<String> _items = [];
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _hasError = false;
  static const _limit = 20;

  @override
  void initState() {
    _getPosts();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_items.isEmpty) {
      content = _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const EmptyListWidget();
    } else {
      content = Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        interactive: true,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: _items.length + 1,
          itemBuilder: (context, index) {
            if (index < _items.length) {
              final item = _items[index];
              return ListTile(title: Text(item));
            } else {
              return _listLastItem();
            }
          },
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: MyPaginationWidget(
          onLoadMore: _getPosts,
          child: content,
        ),
      ),
    );
  }

  Widget _listLastItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: _hasMore
            ? _hasError
            ? const Text('Failed to get data')
            : const CircularProgressIndicator()
            : const Text('No more data to load'),
      ),
    );
  }

  Future<void> _getPosts() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    try {
      _isLoading = true;
      _hasError = false;
      setState(() {});

      final url = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=$_limit&_page=$_page',
      );
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'FlutterApp/1.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List newItems = json.decode(response.body);
        if (newItems.length < _limit) {
          _hasMore = false;
        }
        setState(() {
          _page++;
          _isLoading = false;
          _hasError = false;
          _items.addAll(
            newItems.map<String>((item) {
              final number = item['id'];
              return 'Item $number';
            }),
          );
        });
      } else {
        _hasError = true;
        _isLoading = false;
        setState(() {});
      }
    } catch (_) {
      _isLoading = false;
      _hasError = true;
      setState(() {});
    }
  }
}
