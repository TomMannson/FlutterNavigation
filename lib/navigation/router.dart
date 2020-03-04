import 'package:flutter/cupertino.dart';
import 'package:flutter_navigation/screens/news_screen/new_screen.dart';

class Router extends StatelessWidget {
  BuildContext _context;

  static Router of(BuildContext context) => Router(context);

  Router(BuildContext context) {
    _context = context;
  }

  NewsRouter get news => NewsRouter(_context);
  ShopRouter get shop => ShopRouter(_context);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class RootRouter {
  BuildContext context;

  RootRouter(this.context);

  void back() {
    //Navigator.pop()
  }
}

class NewsRouter extends RootRouter {
  NewsRouter(BuildContext context) : super(context);

  void openList() {
    Navigator.of(context)
        .pushAndRemoveUntil(NewsScreen.route(), (route) => false);
  }
}

class ShopRouter extends RootRouter {
  ShopRouter(BuildContext context) : super(context);
}

class CarsRouter extends RootRouter {
  CarsRouter(BuildContext context) : super(context);

  void navigateDetails(int data) {
//    Navigator.of(context).push(NewsScreen.route());
  }

  void openHandbook() {}
}
