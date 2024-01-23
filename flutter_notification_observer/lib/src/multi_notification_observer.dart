import 'package:flutter/widgets.dart';
import 'package:flutter_notification_observer/flutter_notification_observer.dart';

final class MultiNotificationObserver extends StatefulWidget {
  const MultiNotificationObserver({
    super.key,
    required this.observers,
    required this.child,
  });

  final List<NotificationObserver> observers;

  /// The child widget.
  final Widget child;

  @override
  State<MultiNotificationObserver> createState() =>
      _MultiNotificationObserverState();
}

class _MultiNotificationObserverState extends State<MultiNotificationObserver> {
  @override
  void initState() {
    super.initState();

    for (final observer in widget.observers) {
      NotificationDispatcher.instance.addObserver(
        this,
        name: observer.name,
        onMessageReceived: observer.onMessageReceived,
      );
    }
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MultiNotificationObserver oldWidget) {
    super.didUpdateWidget(oldWidget);

    NotificationDispatcher.instance.removeObserver(this);
    for (final observer in widget.observers) {
      NotificationDispatcher.instance.addObserver(
        this,
        name: observer.name,
        onMessageReceived: observer.onMessageReceived,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
