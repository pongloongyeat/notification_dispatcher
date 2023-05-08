import 'dart:async';

import 'package:notification_dispatcher/src/notification_dispatcher.dart';
import 'package:test/test.dart';

class TestHelper {
  TestHelper(this.name);

  final String name;
}

}

void main() {
  group('NotificationDispatcher', () {
    final instance = TestHelper('1');
    final anotherInstance = TestHelper('1');

    const observerName = 'name';
    const observerName2 = '${observerName}2';

    test('adds an observer on addObserver', () {
      MockNotificationDispatcher.instance.addObserver(
        instance,
        name: observerName,
        callback: (_) {},
      );

      expect(
        MockNotificationDispatcher.instance.observers.containsKey(instance),
        true,
      );
      expect(
        MockNotificationDispatcher.instance.observers[instance]
            ?.containsKey(observerName),
        true,
      );

      MockNotificationDispatcher.instance.clearAll();
    });

    test('is able to add multiple observers', () {
      MockNotificationDispatcher.instance
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
        MockNotificationDispatcher.instance.observers[instance]
            ?.containsKey(observerName),
        true,
      );
      expect(
        MockNotificationDispatcher.instance.observers[anotherInstance]
            ?.containsKey(observerName2),
        true,
      );
      expect(MockNotificationDispatcher.instance.observers.keys.length, 2);
    });

    test('removes all callbacks associated with observer on removeObserver',
        () {
      var callCount = 0;

      MockNotificationDispatcher.instance
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
      MockNotificationDispatcher.instance.clearAll();
    });

    test(
        'removes all callbacks associated with observer on removeObserver '
        'given multiple registered observers of the same class', () {
      var callCount = 0;

      MockNotificationDispatcher.instance
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
      MockNotificationDispatcher.instance.clearAll();
    });

    test('is able to remove a specific callback on remove', () {
      var callCount = 0;

      MockNotificationDispatcher.instance
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
        ..remove(observer: instance, name: observerName2)
        ..post(name: observerName)
        ..post(name: observerName2);

      expect(callCount, 1);
      MockNotificationDispatcher.instance.clearAll();
    });

    test('calls registered callback on post', () {
      var callCount = 0;

      MockNotificationDispatcher.instance
        ..addObserver(
          instance,
          name: observerName,
          callback: (message) => callCount = message.info!['callCount'] as int,
        )
        ..post(name: observerName, info: {'callCount': 1});

      expect(callCount, 1);
      MockNotificationDispatcher.instance.clearAll();
    });

    test('calls futures on post', () async {
      var callCount = 0;
      const delay = Duration(milliseconds: 100);

      MockNotificationDispatcher.instance.addObserver(
        instance,
        name: observerName,
        callback: (_) async => Future.delayed(
          delay,
          () => callCount++,
        ),
      );

      unawaited(MockNotificationDispatcher.instance.post(name: observerName));
      expect(callCount, 0);
      await Future.delayed(delay);
      expect(callCount, 1);

      await MockNotificationDispatcher.instance.post(name: observerName);
      expect(callCount, 2);

      MockNotificationDispatcher.instance.clearAll();
    });
  });
}
