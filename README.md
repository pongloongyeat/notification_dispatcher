Inspired by Apple's [NotificationCenter](https://developer.apple.com/documentation/foundation/notificationcenter). Passes information around to registered observers.

## Usage

```dart
import 'package:notification_dispatcher/notification_dispatcher.dart';

class YourClass {
  int count = 0;

  void init() {
    NotificationDispatcher.instance.addObserver(
      observer: YourClass,
      name: 'increment',
      callback: () => count++,
    );
  }

  void dispose() {
    NotificationDispatcher.instance.removeObserver(YourClass);
  }
}

void main() {
  final yourClass = YourClass()..init();
  NotificationDispatcher.instance.post(name: 'increment');
  print(yourClass.count);     // Prints 1
  yourClass.dispose();
}
```

## Flutter Example
```dart
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    NotificationDispatcher.instance.addObserver(
      observer: _AppState,
      name: 'observerName',
      callback: () => setState(() => count++),
    );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(_AppState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$count'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    NotificationDispatcher.instance.post(name: 'observerName'),
                child: const Text('Increment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
