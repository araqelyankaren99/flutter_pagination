import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListRefreshWidget extends StatelessWidget {
  const ListRefreshWidget({
    super.key,
    required this.refreshController,
    required this.refresh,
    required this.loading,
    required this.list,
    this.scrollController,
  });

  final RefreshController refreshController;
  final VoidCallback refresh;
  final VoidCallback loading;
  final Widget list;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: const ClassicHeader(
        releaseText: '',
        completeText: '',
        completeIcon: null,
        idleText: '',
      ),
      footer: const ClassicFooter(
        loadingText: '',
        canLoadingText: '',
        idleText: '',
        idleIcon: null,
      ),
      controller: refreshController,
      scrollController: scrollController,
      onRefresh: refresh,
      onLoading: loading,
      child: list,
    );
  }
}