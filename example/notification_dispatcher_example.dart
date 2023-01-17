import 'package:notification_dispatcher/notification_dispatcher.dart';

class YourClass {
  int count = 0;

  void init() {
    NotificationDispatcher.instance.addObserver(
      observer: YourClass,
      name: 'observerName',
      callback: () => count++,
    );
  }

  void dispose() {
    NotificationDispatcher.instance.removeObserver(YourClass);
  }
}

void main() {
  final yourClass = YourClass()..init();
  NotificationDispatcher.instance.post(name: 'observerName');

  print(yourClass.count); // 1
  yourClass.dispose();
}
