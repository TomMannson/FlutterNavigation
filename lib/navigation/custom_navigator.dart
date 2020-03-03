import 'package:flutter/material.dart';

class CustomNavigator extends Navigator {
  const CustomNavigator({
    Key key,
    String initialRoute,
    RouteFactory onGenerateRoute,
    RouteFactory onUnknownRoute,
    List<NavigatorObserver> observers = const <NavigatorObserver>[],
  })  : assert(onGenerateRoute != null),
        super(
          key: key,
          initialRoute: initialRoute,
          onGenerateRoute: onGenerateRoute,
          onUnknownRoute: onGenerateRoute,
          observers: observers,
        );

  @override
  NavigatorState createState() {
    return CustomNavigatorState();
  }
}

class CustomNavigatorState extends NavigatorState {
  final List<Route<dynamic>> history = <Route<dynamic>>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    history.clear();
    super.dispose();
  }

  @override
  Future<T> push<T extends Object>(Route<T> route) {
    history.add(route);
    return super.push(route);
  }

  @override
  Future<T> pushReplacement<T extends Object, TO extends Object>(
      Route<T> newRoute,
      {TO result}) {
    final int index = history.length - 1;
    history[index] = newRoute;
    return super.pushReplacement(newRoute, result: result);
  }

  @override
  void replace<T extends Object>({Route oldRoute, Route<T> newRoute}) {
    final int index = history.indexOf(oldRoute);
    history[index] = newRoute;
    super.replace(oldRoute: oldRoute, newRoute: newRoute);
  }

  @override
  Future<T> pushAndRemoveUntil<T extends Object>(Route<T> newRoute, predicate) {
    while (history.isNotEmpty && !predicate(history.last)) {
      history.removeLast();
    }
    history.add(newRoute);
    return super.pushAndRemoveUntil(newRoute, predicate);
  }

  @override
  bool pop<T extends Object>([T result]) {
    if (history.length > 1) {
      history.removeLast();
    }
    return super.pop(result);
  }

  @override
  void removeRoute(Route route) {
    int index = history.indexOf(route);
    history.removeAt(index);
    super.removeRoute(route);
  }
}
