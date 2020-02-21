import 'package:flutter/material.dart';
import 'package:flutter_navigation/navigation/root_navigator.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key, this.title = "Flutter Page Two"}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NewsScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NewsScreenStarter extends NavigationHandler<dynamic, bool> {
  @override
  Widget createTarget(BuildContext ctx, data) => NewsScreen();

  @override
  Future<RouteAction<bool>> canRoute(
    BuildContext ctx,
    CurrentNavState state,
  ) async {
    await Future.delayed(Duration(seconds: 2));

    return AuthenticationAction();
  }
}
