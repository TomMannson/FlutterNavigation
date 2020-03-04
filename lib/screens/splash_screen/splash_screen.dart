import 'package:flutter/material.dart';
import 'package:flutter_navigation/screens/news_screen/new_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title = "Splash Screen"}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  static Route route() {
    return MaterialPageRoute(builder: (ctx) => SplashScreen());
  }
}

class _MyHomePageState extends State<SplashScreen> {
  bool _isProgress = false;

  void _incrementCounter() async {
    Navigator.of(context).pushReplacement(NewsScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildContent() {
    if (_isProgress) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox();
  }
}
