import 'package:notification_dispatcher/src/notification_dispatcher.dart';
import 'package:test/test.dart';

class TestHelper {
  TestHelper(this.name);

  final String name;
}

void main() {
  group('NotificationDispatcher', () {
    final instance = TestHelper('1');
    final anotherInstance = TestHelper('1');

    const observerName = 'name';
    const observerName2 = '${observerName}2';

    tearDown(NotificationDispatcher.instance.clearAll);

    test('adds an observer on addObserver', () {
      NotificationDispatcher.instance.addObserver(
        instance,
        name: observerName,
        callback: (_) {},
      );

      expect(
        NotificationDispatcher.instance.observers.containsKey(instance),
        true,
      );
      expect(
        NotificationDispatcher.instance.observers[instance]
            ?.containsKey(observerName),
        true,
      );
    });

    test('is able to add multiple observers', () {
      NotificationDispatcher.instance
        ..addObserver(
          instance,
          name: observerName,
          callback: (_) {},
        )
        ..addObserver(
          anotherInstance,
          name: observerName2,
          callback: (_) {},
        );

      expect(
        NotificationDispatcher.instance.observers[instance]
            ?.containsKey(observerName),
        true,
      );
      expect(
        NotificationDispatcher.instance.observers[anotherInstance]
            ?.containsKey(observerName2),
        true,
      );
      expect(NotificationDispatcher.instance.observers.keys.length, 2);
    });

    test('removes all callbacks associated with observer on removeObserver',
        () {
      var callCount = 0;

      NotificationDispatcher.instance
        ..addObserver(
          instance,
          name: observerName,
          callback: (_) => callCount++,
        )
        ..addObserver(
          instance,
          name: observerName2,
          callback: (_) => callCount += 2,
        )
        ..removeObserver(instance)
        ..post(name: observerName)
        ..post(name: observerName2);

      expect(callCount, 0);
    });

    test(
        'removes all callbacks associated with observer on removeObserver '
        'given multiple registered observers of the same class', () {
      var callCount = 0;

      NotificationDispatcher.instance
        ..addObserver(
          instance,
          name: observerName,
          callback: (_) => callCount++,
        )
        ..addObserver(
          instance,
          name: observerName2,
          callback: (_) => callCount += 2,
        )
        ..addObserver(
          anotherInstance,
          name: observerName,
          callback: (_) => callCount += 3,
        )
        ..addObserver(
          anotherInstance,
          name: observerName2,
          callback: (_) => callCount += 4,
        )
        ..removeObserver(anotherInstance)
        ..post(name: observerName)
        ..post(name: observerName2);

      expect(callCount, 3);
    });

    test('is able to remove a specific callback on remove', () {
      var callCount = 0;

      NotificationDispatcher.instance
        ..addObserver(
          instance,
          name: observerName,
          callback: (_) => callCount++,
        )
        ..addObserver(
          instance,
          name: observerName2,
          callback: (_) => callCount += 2,
        )
        ..removeObserverWith(instance, name: observerName2)
        ..post(name: observerName)
        ..post(name: observerName2);

      expect(callCount, 1);
    });

    test('calls registered callback on post', () {
      var callCount = 0;

      NotificationDispatcher.instance
        ..addObserver(
          instance,
          name: observerName,
          callback: (message) => callCount = message!['callCount'] as int,
        )
        ..post(name: observerName, info: {'callCount': 1});

      expect(callCount, 1);
    });
  });
}
