import 'package:flutter/cupertino.dart';

class Router extends StatelessWidget {
//  static Router of(BuildContext context) =>

  NewsRouter news() => NewsRouter();
  ShopRouter shop;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class RootRouter {
  BuildContext context;

  void back() {
    //Navigator.pop()
  }
}

class NewsRouter extends RootRouter {
  void openList() {}
}

class ShopRouter extends RootRouter {}

class CarsRouter extends RootRouter {
  void navigateDetails(int data) {}
  void openHandbook() {}
}
