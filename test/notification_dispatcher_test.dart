import 'package:notification_dispatcher/src/notification_dispatcher.dart';
import 'package:test/test.dart';

class TestHelper {}

void main() {
  group('NotificationDispatcher', () {
    final instance = TestHelper();
    final anotherInstance = TestHelper();

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

    test('is able to remove a specific callback on remove', () {
      var callCount = 0;

      MockNotificationDispatcher.instance
        ..addObserver(
          instance,
          name: observerName,
          callback: (_) => callCount++,
        )
        ..addObserver(
          anotherInstance,
          name: observerName2,
          callback: (_) => callCount += 2,
        )
        ..remove(observer: anotherInstance, name: observerName2)
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
  });
}
