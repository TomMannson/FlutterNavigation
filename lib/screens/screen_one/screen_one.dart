import 'package:flutter/material.dart';
import 'package:flutter_navigation/navigation/root_navigator.dart';
import 'package:flutter_navigation/screens/screen_two/new_screen.dart';

class ScreenOne extends StatefulWidget {
  ScreenOne({Key key, this.title = "Screen One"}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ScreenOne> {
  bool _isProgress = false;

  void _incrementCounter() async {
    setState(() {
      _isProgress = true;
    });
    final data = await NavigateTo.replace(context, NewsScreenStarter());
    setState(() {
      _isProgress = false;
    });
    data.toString();
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