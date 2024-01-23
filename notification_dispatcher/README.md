[![Build status](https://github.com/pongloongyeat/notification_dispatcher/actions/workflows/dart.yaml/badge.svg)](https://github.com/pongloongyeat/notification_dispatcher/actions/workflows/dart.yaml)
[![Pub package](https://img.shields.io/pub/v/notification_dispatcher.svg)](https://pub.dev/packages/notification_dispatcher)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Inspired by Apple's [NotificationCenter](https://developer.apple.com/documentation/foundation/notificationcenter). Passes information around to registered observers.

## Installing

Add the following line to your `pubspec.yaml` file.

```yaml
notification_dispatcher: ^0.4.0
```

## Flutter Example
```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    // Add this instance as an observer and call _incrementCounter when we
    // receive a notification with the name 'increment'.
    NotificationDispatcher.instance.addObserver(
      this,
      name: 'increment',
      callback: (_) => _incrementCounter(),
    );
  }

  @override
  void dispose() {
    // Make sure to remove this instance as an observer to prevent callbacks
    // from running if we receive a notification with the name 'increment'.
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotificationDispatcher Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Post a notification with the name 'increment' to fire our
        // _incrementCounter callback.
        onPressed: () =>
            NotificationDispatcher.instance.post(name: 'increment'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
