
import 'package:flutter/material.dart';

class MyPaginationWidget extends StatelessWidget {
  const MyPaginationWidget({
    super.key,
    required this.onLoadMore,
    required this.child,
    this.hasMore = true,
  });

  final VoidCallback onLoadMore;
  final Widget child;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: _onNotificationCallback,
      child: child,
    );
  }

  bool _onNotificationCallback(ScrollEndNotification notification){
    if (notification.metrics.maxScrollExtent == notification.metrics.pixels) {
      if(hasMore) {
        onLoadMore();
      }
      return true;
    }
    return false;
  }
}
