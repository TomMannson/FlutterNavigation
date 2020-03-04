import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_navigation/navigation/filters/auth_filter.dart';
import 'package:flutter_navigation/screens/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

import 'custom_navigator.dart';

class NavRoot extends StatefulWidget {
  final String initialLink;
  final CurrentNavState startUp;

  const NavRoot({
    Key key,
    this.initialLink,
    this.startUp,
  }) : super(key: key);

  State createState() {
    return _NavRootState();
  }
}

class _NavRootState extends State<NavRoot> implements NavDelegate {
  CurrentNavState _navState = new CurrentNavState();
  GlobalKey<NavigatorState> key;
  String startLink;
  NavigationDispatcher dispather = NavigationDispatcher([
    AuthFilter(),
  ]);

  void initState() {
    startLink = widget.initialLink;
    super.initState();
  }

  Widget build(BuildContext context) {
    key = GlobalKey<NavigatorState>();
    NavDelegate delegate = this;
    return MultiProvider(
      providers: [Provider.value(value: delegate)],
      child: MaterialApp(
        builder: buildNavigator,
        navigatorKey: key,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: buildDefaultHomeContent(),
      ),
    );
  }

  Widget buildNavigator(BuildContext context, Widget widget) {
    Navigator navigator = widget;
    return CustomNavigator(
      key: navigator.key,
      navigationDelegate: this,
      dispatcher: dispather,
      initialRoute: navigator.initialRoute,
      onGenerateRoute: navigator.onGenerateRoute,
      onUnknownRoute: navigator.onUnknownRoute,
      observers: navigator.observers,
    );
  }

  Widget buildDefaultHomeContent() {
    return SplashScreen();
  }

  @override
  String getLink() {
    return startLink;
  }

  @override
  CurrentNavState getNavState() {
    return _navState;
  }
}

abstract class NavDelegate {
  String getLink();
  CurrentNavState getNavState();
}

class CurrentNavState {
  bool isLoggedIn = false;
}

class Link {
  String link;

  Link(this.link);
}

class NavResult {
  Future result;
}

class OkResult extends NavResult {}

class CancelResult extends NavResult {}

abstract class NavigationFilter {
  NavResult canActivate(NavigatorState navigatorState, BuildContext context,
      CurrentNavState state, Route<dynamic> action);
}

class NavigationDispatcher {
  List<NavigationFilter> filters = [];

  NavigationDispatcher(this.filters);

  NavResult performNavAction(
    NavigatorState navigatorState,
    BuildContext context,
    CurrentNavState state,
    Route<dynamic> action,
  ) {
    NavResult result = OkResult();
    for (NavigationFilter filter in filters) {
      result = filter.canActivate(navigatorState, context, state, action);
      if (result is CancelResult) {
        return result;
      }
    }
    return result;
  }
}
