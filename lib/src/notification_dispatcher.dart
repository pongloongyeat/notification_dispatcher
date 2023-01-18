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

/// The [NotificationDispatcher] class. Passes information around
/// to registered observers. The class comes with a default instance
/// named [NotificationDispatcher.instance].
class NotificationDispatcher {
  NotificationDispatcher._();

  /// The current instance of [NotificationDispatcher].
  static final instance = NotificationDispatcher._();
  final _observers = <Object, Map<String, NotificationCallback>>{};

  /// Adds an observer. Because of [removeObserver] and [remove],
  /// make sure that the == operator for [observer] returns true
  /// if and only if the compared object is the same object (which
  /// is the default behaviour for Dart).
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
  /// Make sure that the == operator for [observer] returns true
  /// if and only if the compared object is the same object (which
  /// is the default behaviour for Dart).
  void removeObserver(Object observer) {
    _observers.removeWhere((key, _) => key == observer);
  }

  /// Removes all callbacks associated with [observer] and [name].
  /// Make sure that the == operator for [observer] returns true
  /// if and only if the compared object is the same object (which
  /// is the default behaviour for Dart).
  void remove({required Object observer, required String name}) {
    if (!_observers.containsKey(observer)) return;
    _observers[observer]!.removeWhere((key, _) => key == name);
  }

  /// Posts a notification, running all callbacks registered
  /// with [name] while passing an optional [sender] and [info].
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
