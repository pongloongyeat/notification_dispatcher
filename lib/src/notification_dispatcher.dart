typedef NotificationCallback = void Function(NotificationMessage);

/// The class used to store a notification's payload.
class NotificationMessage {
  const NotificationMessage({
    required this.sender,
    required this.info,
  });

  /// The sender posting the notification
  final Object? sender;

  /// The info being posted with the notification.
  final Map<String, dynamic>? info;
}

class NotificationDispatcher {
  NotificationDispatcher._();

  static final instance = NotificationDispatcher._();
  final _observers = <Object, Map<String, NotificationCallback>>{};

  void addObserver(
    Object observer, {
    required String name,
    required NotificationCallback callback,
  }) {
    if (_observers.containsKey(observer)) {
      _observers[observer]!.addAll({name: callback});
      return;
    }

    _observers[observer] = {name: callback};
  }

  /// Removes all callbacks associated with [observer].
  void removeObserver(Object observer) {
    _observers.removeWhere((key, _) => key == observer);
  }

  /// Removes all callbacks associated with [observer] and [name].
  void remove({required Object observer, required String name}) {
    if (!_observers.containsKey(observer)) return;
    _observers[observer]!.removeWhere((key, _) => key == name);
  }

  /// Posts a notification, running all callbacks registered
  void post({
    Object? sender,
    required String name,
    Map<String, dynamic>? info,
  }) {
    for (final callback in _observers.values) {
      callback[name]?.call(NotificationMessage(sender: sender, info: info));
    }
  }
}

class MockNotificationDispatcher extends NotificationDispatcher {
  MockNotificationDispatcher._() : super._();

  static final instance = MockNotificationDispatcher._();
  Map<Object, Map<String, NotificationCallback>> get observers => _observers;

  void clearAll() => _observers.clear();
}
