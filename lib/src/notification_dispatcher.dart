typedef VoidCallback = void Function();

class NotificationDispatcher {
  NotificationDispatcher._();

  static final instance = NotificationDispatcher._();
  final _observers = <Type, Map<String, VoidCallback>>{};

  /// Adds an observer.
  void addObserver({
    required Type observer,
    required String name,
    required VoidCallback callback,
  }) {
    if (_observers.containsKey(observer)) {
      _observers[observer]!.addAll({name: callback});
      return;
    }

    _observers[observer] = {name: callback};
  }

  /// Removes all callbacks associated with [observer].
  void removeObserver(Type observer) {
    _observers.removeWhere((key, _) => key.toString() == observer.toString());
  }

  /// Removes all callbacks associated with [observer] and [name].
  void remove({required Type observer, required String name}) {
    if (!_observers.containsKey(observer)) return;
    _observers[observer]!.removeWhere((key, _) => key == name);
  }

  /// Posts a notification, running all callbacks registered
  /// with [name].
  void post({required String name}) {
    for (final callback in _observers.values) {
      callback[name]?.call();
    }
  }
}

class MockNotificationDispatcher extends NotificationDispatcher {
  MockNotificationDispatcher._() : super._();

  static final instance = MockNotificationDispatcher._();
  Map<Type, Map<String, VoidCallback>> get observers => _observers;

  void clearAll() => _observers.clear();
}
