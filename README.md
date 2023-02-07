[![Build status](https://github.com/pongloongyeat/notification_dispatcher/actions/workflows/dart.yaml/badge.svg)](https://github.com/pongloongyeat/notification_dispatcher/actions/workflows/dart.yaml)
[![Pub package](https://img.shields.io/pub/v/notification_dispatcher.svg)](https://pub.dev/packages/notification_dispatcher)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Inspired by Apple's [NotificationCenter](https://developer.apple.com/documentation/foundation/notificationcenter). Passes information around to registered observers.

## Installing

Add the following line to your `pubspec.yaml` file.

```yaml
notification_dispatcher: ^0.3.2
```

## Flutter Example
```dart
void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    NotificationDispatcher.instance.addObserver(
      this,
      name: 'observerName',
      callback: (_) => _incrementCount(),
    );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  void _incrementCount() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_count',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              NotificationDispatcher.instance.post(name: 'observerName'),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

## Equatable

To set an [Equatable](https://pub.dev/packages/equatable)-extended class as an observer, use the `NotificationDispatcherEquatableObserverMixin` mixin and add the `instanceKey` property to its `props` property.

```dart
class SomeClass extends Equatable with NotificationDispatcherEquatableObserverMixin {
  @override
  List<Object?> get props => [...super.props, instanceKey];
}
```
