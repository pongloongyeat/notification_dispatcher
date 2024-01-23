import 'package:flutter/material.dart';
import 'package:flutter_notification_observer/flutter_notification_observer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotificationObserver Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'NotificationObserver Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    final counter = ++_counter;
    NotificationDispatcher.instance
        .post(name: 'increment', message: {'count': counter});

    if (counter.isEven) {
      NotificationDispatcher.instance.post(name: 'even');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title});

  final String title;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return MultiNotificationObserver(
      observers: [
        NotificationObserver(
          name: 'increment',
          onMessageReceived: (message) {
            final count = message?['count'];
            if (count is! int) return;
            setState(() => _count = count);
          },
        ),
        NotificationObserver(
          name: 'even',
          onMessageReceived: (_) => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => const Dialog(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('You got an even number!'),
              ),
            ),
          ),
        ),
      ],
      child: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(_count == 0 ? widget.title : '$_count'),
      ),
    );
  }
}
