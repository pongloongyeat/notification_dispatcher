/// Callback signature when receiving a notification.
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

  /// The observer map. When filled, it looks like this
  ///
  /// {
  ///   InstanceOfYourObject: {
  ///     "notificationName": () {},
  ///   },
  ///   ...
  /// }
  Map<Object, Map<String, NotificationCallback>> get observers => _observers;

  /// Adds an observer with its registered callback.
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

  /// Removes all callbacks associated to the same reference/instance
  /// as [observer] as when it was registered when calling [addObserver].
  void removeObserver(Object observer) {
    _observers.removeWhere((key, _) => identical(key, observer));
  }

  /// Removes all callbacks associated to the same reference/instance
  /// as [observer] as when it was registered when calling [addObserver]
  /// with [name].
  void removeObserverWith(Object observer, {required String name}) {
    _observers[observer]?.removeWhere((key, _) => key == name);
  }

  /// Posts a notification, running all callbacks registered
  /// with [name] while passing an optional [sender] and [info].
  void post({
    Object? sender,
    required String name,
    Map<String, dynamic>? info,
  }) {
    for (final callback in _observers.values.toList()) {
      callback[name]?.call(
        NotificationMessage(
          sender: sender,
          info: info,
        ),
      );
    }

    return;
  }
}
