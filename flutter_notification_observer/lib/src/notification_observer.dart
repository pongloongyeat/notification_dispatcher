import 'package:flutter/widgets.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

/// {@template NotificationObserver}
/// A widget for observing notifications from the current instance of
/// [NotificationDispatcher].
/// {@endtemplate}
final class NotificationObserver extends StatefulWidget {
  /// {@macro NotificationObserver}
  const NotificationObserver({
    super.key,
    required this.name,
    required this.onMessageReceived,
    this.child,
  });

  /// The notification name to observe.
  final String name;

  /// The callback to fire when receiving a notification matching [name].
  final NotificationCallback onMessageReceived;

  /// The child widget.
  final Widget? child;

  @override
  State<NotificationObserver> createState() => _NotificationObserverState();
}

final class _NotificationObserverState extends State<NotificationObserver> {
  @override
  void initState() {
    super.initState();
    NotificationDispatcher.instance.addObserver(
      this,
      name: widget.name,
      onMessageReceived: widget.onMessageReceived,
    );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NotificationObserver oldWidget) {
    super.didUpdateWidget(oldWidget);

    NotificationDispatcher.instance
      ..removeObserver(this)
      ..addObserver(this,
          name: widget.name, onMessageReceived: widget.onMessageReceived);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
