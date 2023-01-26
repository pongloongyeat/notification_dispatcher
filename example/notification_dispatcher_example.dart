import 'package:notification_dispatcher/notification_dispatcher.dart';

class YourClass {
  int count = 0;

  void init() {
    NotificationDispatcher.instance.addObserver(
      this,
      name: 'observerName',
      callback: (_) => count++,
    );
  }
}

void main() {
  final yourClass = YourClass()..init();
  NotificationDispatcher.instance.post(name: 'observerName');

  print(yourClass.count); // 1
}
