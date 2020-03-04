import 'package:flutter/material.dart';
import 'package:flutter_navigation/navigation/root_navigator.dart';

class CustomNavigator extends Navigator {
  final NavDelegate navigationDelegate;
  final NavigationDispatcher dispatcher;

  CustomNavigator({
    Key key,
    this.dispatcher,
    this.navigationDelegate,
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

  NavDelegate navigationDelegate;
  NavigationDispatcher dispatcher;

  @override
  void initState() {
    CustomNavigator navigator = widget as CustomNavigator;
    navigationDelegate = navigator.navigationDelegate;
    dispatcher = navigator.dispatcher;
    super.initState();
  }

  @override
  void dispose() {
    history.clear();
    super.dispose();
  }

  @override
  Future<T> push<T extends Object>(Route<T> route) {
    if (dispatcher.performNavAction(
            this, context, navigationDelegate.getNavState(), route)
        is CancelResult) {
      return Future.value(null);
    }

    history.add(route);
    return super.push(route);
  }

  @override
  Future<T> pushReplacement<T extends Object, TO extends Object>(
      Route<T> newRoute,
      {TO result}) {
    if (dispatcher.performNavAction(
            this, context, navigationDelegate.getNavState(), newRoute)
        is CancelResult) {
      return Future.value(null);
    }
    final int index = history.length - 1;
    history[index] = newRoute;
    return super.pushReplacement(newRoute, result: result);
  }

  @override
  void replace<T extends Object>({Route oldRoute, Route<T> newRoute}) {
    if (dispatcher.performNavAction(
            this, context, navigationDelegate.getNavState(), newRoute)
        is CancelResult) {
      return;
    }
    final int index = history.indexOf(oldRoute);
    history[index] = newRoute;
    super.replace(oldRoute: oldRoute, newRoute: newRoute);
  }

  @override
  Future<T> pushAndRemoveUntil<T extends Object>(Route<T> newRoute, predicate) {
    if (dispatcher.performNavAction(
            this, context, navigationDelegate.getNavState(), newRoute)
        is CancelResult) {
      return Future.value(null);
    }
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

class AttributeMaterialPageRoute extends MaterialPageRoute {
  List attributes;

  AttributeMaterialPageRoute({
    WidgetBuilder builder,
    this.attributes,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        assert(opaque),
        super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}
