import 'typedefs.dart';

/// Passes notifications around to registered observers. The class comes with a
/// default instance named [NotificationDispatcher.instance].
final class NotificationDispatcher {
  NotificationDispatcher._();

  /// The current instance of [NotificationDispatcher].
  static final instance = NotificationDispatcher._();

  final _observers = <Object, Map<String, NotificationCallback>>{};

  /// {@template NotificationDispatcher.addObserver}
  /// Adds an observer to the current [NotificationDispatcher] instance with
  /// its callback.
  ///
  /// When [post] is called, all observers matching [name] will be called.
  /// {@endtemplate}
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

  /// {@template NotificationDispatcher.removeObserver}
  /// Removes the [observer] from the current [NotificationDispatcher] instance.
  /// {@endtemplate}
  void removeObserver(Object observer) {
    _observers.removeWhere((key, _) => key == observer);
  }

  /// {@template NotificationDispatcher.removeObserverWith}
  /// Removes all callbacks associated to [observer] with [name] from the
  /// current [NotificationDispatcher] instance.
  /// {@endtemplate}
  void removeObserverWith(
    Object observer, {
    required String name,
  }) {
    _observers[observer]?.removeWhere((key, _) => key == name);
  }

  /// {@template NotificationDispatcher.post}
  /// Posts a notification to the current [NotificationDispatcher] instance,
  /// running all callbacks registered with [name].
  /// {@endtemplate}
  void post({
    required String name,
    NotificationMessage? info,
  }) {
    for (final callback in _observers.values.toList()) {
      callback[name]?.call(info);
    }

    return;
  }
}

extension NotificationDispatcherTestExtension on NotificationDispatcher {
  Map<Object, Map<String, NotificationCallback>> get observers => _observers;
  void clearAll() => observers.clear();
}
