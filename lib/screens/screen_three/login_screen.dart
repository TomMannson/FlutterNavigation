import 'package:flutter/material.dart';
import 'package:flutter_navigation/navigation/root_navigator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.returnRoute, {Key key, this.title = "Login Page"})
      : super(key: key);
  final String title;
  final Route returnRoute;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  static Route route(Route returnRoute) {
    return MaterialPageRoute(builder: (ctx) => LoginScreen(returnRoute));
  }
}

class _MyHomePageState extends State<LoginScreen> {
  int _counter = 0;

  void _incrementCounter() {
    Provider.of<NavDelegate>(context, listen: false).getNavState().isLoggedIn =
        true;
    Navigator.of(context).pushReplacement(widget.returnRoute);
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
          children: <Widget>[TextField(), TextField()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
