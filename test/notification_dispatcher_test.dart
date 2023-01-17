import 'package:notification_dispatcher/src/notification_dispatcher.dart';
import 'package:test/test.dart';

class TestHelper {}

class AnotherTestHelper extends TestHelper {}

void main() {
  group('NotificationDispatcher', () {
    const observerName = 'name';
    const observerName2 = '${observerName}2';

    test('adds an observer on addObserver', () {
      MockNotificationDispatcher.instance.addObserver(
        observer: TestHelper,
        name: observerName,
        callback: () {},
      );

      expect(
        MockNotificationDispatcher.instance.observers.containsKey(TestHelper),
        true,
      );
      expect(
        MockNotificationDispatcher.instance.observers[TestHelper]
            ?.containsKey(observerName),
        true,
      );

      MockNotificationDispatcher.instance.clearAll();
    });

    test('is able to add multiple observers', () {
      MockNotificationDispatcher.instance
        ..addObserver(
          observer: TestHelper,
          name: observerName,
          callback: () {},
        )
        ..addObserver(
          observer: AnotherTestHelper,
          name: observerName2,
          callback: () {},
        );

      expect(
        MockNotificationDispatcher.instance.observers[TestHelper]
            ?.containsKey(observerName),
        true,
      );
      expect(
        MockNotificationDispatcher.instance.observers[AnotherTestHelper]
            ?.containsKey(observerName2),
        true,
      );
    });

    test('removes all callbacks associated with observer on removeObserver',
        () {
      var callCount = 0;

      MockNotificationDispatcher.instance
        ..addObserver(
          observer: TestHelper,
          name: observerName,
          callback: () => callCount++,
        )
        ..addObserver(
          observer: TestHelper,
          name: observerName2,
          callback: () => callCount += 2,
        )
        ..removeObserver(TestHelper)
        ..post(name: observerName)
        ..post(name: observerName2);

      expect(callCount, 0);
      MockNotificationDispatcher.instance.clearAll();
    });

    test('is able to remove a specific callback on remove', () {
      var callCount = 0;

      MockNotificationDispatcher.instance
        ..addObserver(
          observer: TestHelper,
          name: observerName,
          callback: () => callCount++,
        )
        ..addObserver(
          observer: AnotherTestHelper,
          name: observerName2,
          callback: () => callCount += 2,
        )
        ..remove(observer: AnotherTestHelper, name: observerName2)
        ..post(name: observerName)
        ..post(name: observerName2);

      expect(callCount, 1);
      MockNotificationDispatcher.instance.clearAll();
    });

    test('calls registered callback on post', () {
      var callCount = 0;

      MockNotificationDispatcher.instance
        ..addObserver(
          observer: TestHelper,
          name: observerName,
          callback: () => callCount++,
        )
        ..post(name: observerName);

      expect(callCount, 1);
      MockNotificationDispatcher.instance.clearAll();
    });
  });
}
