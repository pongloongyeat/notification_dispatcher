Inspired by Apple's [NotificationCenter](https://developer.apple.com/documentation/foundation/notificationcenter). Passes information around to registered observers.

[![Build status](https://github.com/pongloongyeat/notification_dispatcher/actions/workflows/dart.yaml/badge.svg)](https://github.com/pongloongyeat/notification_dispatcher/actions/workflows/dart.yaml)
[![Pub package](https://img.shields.io/pub/v/notification_dispatcher.svg)](https://pub.dev/packages/notification_dispatcher)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Installing

Add the following line to your `pubspec.yaml` file.

```yaml
notification_dispatcher: ^0.1.0
```

## Usage

```dart
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
      this,
      name: 'observerName',
      callback: (_) => setState(() => count++),
    );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
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
