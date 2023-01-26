import 'package:equatable/equatable.dart';
import 'package:notification_dispatcher/src/notification_dispatcher.dart';
import 'package:test/test.dart';

class TestHelper {
  TestHelper(this.name);

  final String name;
}

class EquatableTestHelper extends Equatable
    with NotificationDispatcherEquatableObserverMixin {
  EquatableTestHelper(this.name);

  final String name;

  @override
  List<Object?> get props => [name, instanceKey];
}

void main() {
  group('NotificationDispatcher', () {
    final instance = TestHelper('1');
    final anotherInstance = TestHelper('1');
    final equatableInstance = EquatableTestHelper('1');
    final anotherEquatableInstance = EquatableTestHelper('1');

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
        )
        ..addObserver(
          equatableInstance,
          name: observerName,
          callback: (_) {},
        )
        ..addObserver(
          anotherEquatableInstance,
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
      expect(
        MockNotificationDispatcher.instance.observers[equatableInstance]
            ?.containsKey(observerName),
        true,
      );
      expect(
        MockNotificationDispatcher.instance.observers[anotherEquatableInstance]
            ?.containsKey(observerName2),
        true,
      );
      expect(MockNotificationDispatcher.instance.observers.keys.length, 4);
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

    test(
        'removes all callbacks associated with observer on removeObserver '
        'given multiple registered observers of the same class with '
        'extends Equatable', () {
      var callCount = 0;

      MockNotificationDispatcher.instance
        ..addObserver(
          equatableInstance,
          name: observerName,
          callback: (_) => callCount++,
        )
        ..addObserver(
          equatableInstance,
          name: observerName2,
          callback: (_) => callCount += 2,
        )
        ..addObserver(
          anotherEquatableInstance,
          name: observerName,
          callback: (_) => callCount += 3,
        )
        ..addObserver(
          anotherEquatableInstance,
          name: observerName2,
          callback: (_) => callCount += 4,
        )
        ..removeObserver(anotherEquatableInstance)
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
  });
}
