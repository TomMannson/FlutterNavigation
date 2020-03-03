import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_navigation/screens/screen_three/login_screen.dart';
import 'package:provider/provider.dart';

import 'actions/actions.dart';
import 'coortinator.dart';
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
  NavObserver observer;
  String startLink;

  void initState() {
    startLink = widget.initialLink;
    super.initState();
  }

  Widget build(BuildContext context) {
    observer = NavObserver(this);
    key = GlobalKey<NavigatorState>();
    NavDelegate delegate = this;
    return MultiProvider(
      providers: [
        Provider.value(value: delegate),
        Provider.value(value: Router()),
      ],
      child: MaterialApp(
        builder: buildNavigator,
        navigatorObservers: [observer],
        navigatorKey: key,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: generateRoute,
        home: buildDefaultHomeContent(),
      ),
    );
  }

  Widget buildNavigator(BuildContext context, Widget widget) {
    Navigator navigator = widget;
    return CustomNavigator(
      key: navigator.key,
      initialRoute: navigator.initialRoute,
      onGenerateRoute: navigator.onGenerateRoute,
      onUnknownRoute: navigator.onUnknownRoute,
      observers: navigator.observers,
    );
  }

  Widget buildDefaultHomeContent() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Future<Result> navigate<Data, Result>(BuildContext ctx,
      NavigationHandler<Data, dynamic> navigate, RoutingMethod<Result> action,
      [Data data]) async {
    RouteAction canRoute = await navigate.canRoute(ctx, _navState);
    return canRoute.navigateConditionally(
        ctx, navigate, action, data, key.currentState);
  }

  @override
  String _getLink() {
    return startLink;
  }

  Route generateRoute(RouteSettings settings) {}
}

class DeepLinkFactory {
//  Route

}

class NavObserver extends NavigatorObserver {
  final _NavRootState _navRootState;

  NavObserver(this._navRootState);

  @override
  void didPush(Route route, Route previousRoute) {
//    _navRootState._navState.last = route;
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {}

  @override
  void didRemove(Route route, Route previousRoute) {}

  @override
  void didPop(Route route, Route previousRoute) {}
}

abstract class NavDelegate {
  Future<Result> navigate<Data, Result>(BuildContext ctx,
      NavigationHandler<Data, dynamic> navigate, RoutingMethod<Result> action,
      [Data data]);

  String _getLink();
}

class CurrentNavState {
  NavAction pendingNav;
  bool isLoggedIn;
}

class NavigateTo {
  static Future<Result> push<Data, Result>(
      BuildContext ctx, NavigationHandler<Data, Result> handler,
      [Data data]) {
    return Provider.of<NavDelegate>(ctx, listen: false)
        .navigate<Data, Result>(ctx, handler, NavigatePush(), data);
  }

  static void replace<Data, Result>(
      BuildContext ctx, NavigationHandler<Data, Result> handler,
      [Data data]) {
    Provider.of<NavDelegate>(ctx, listen: false)
        .navigate<Data, Result>(ctx, handler, NavigateReplace(), data);
  }
}

abstract class NavigationHandler<Data, Result> {
  Future<RouteAction<Result>> canRoute(
    BuildContext ctx,
    CurrentNavState state,
  ) async =>
      GoTo();

  Widget createTarget(BuildContext ctx, Data data);

  Route<Result> prepareRoute(
      BuildContext ctx, Widget lastNav, Widget nextNav, CurrentNavState state) {
    return MaterialPageRoute<Result>(builder: (context) => nextNav);
  }
}

class NavTarget {}

abstract class RoutingMethod<T> {
  Future<T> invokeNavigation(NavigatorState state, Route route);
}

class NavigatePush<T> extends RoutingMethod<T> {
  @override
  Future<T> invokeNavigation(NavigatorState state, Route route) {
    return state.push(route);
  }
}

class NavigateReplace<T> extends RoutingMethod<T> {
  @override
  Future<T> invokeNavigation(NavigatorState state, Route route) {
    state.pushReplacement(route);
    return Future.value(null);
  }
}

abstract class RouteAction<T> {
  Future<T> navigateConditionally(
      BuildContext context,
      NavigationHandler handler,
      RoutingMethod<T> action,
      Object data,
      NavigatorState navigator);
}

class GoTo<T> extends RouteAction<T> {
  @override
  Future<T> navigateConditionally(
      BuildContext context,
      NavigationHandler handler,
      RoutingMethod<T> action,
      Object data,
      NavigatorState navigator) {
    Widget widget = handler.createTarget(context, data);
    Route<T> route = handler.prepareRoute(context, null, widget, null);
    return action.invokeNavigation(navigator, route);
  }
}

class Redirect<T> extends RouteAction<T> {
  NavigationHandler handler;

  @override
  Future<T> navigateConditionally(
      BuildContext context,
      NavigationHandler handler,
      RoutingMethod<T> action,
      Object data,
      NavigatorState navigator) {
    NavigateTo.replace(context, handler);
    return Future.value();
  }
}

class AuthenticationAction<T> extends GoTo<T> {
  @override
  Future<T> navigateConditionally(
    BuildContext context,
    NavigationHandler handler,
    RoutingMethod<T> action,
    Object data,
    NavigatorState navigator,
  ) async {
    final result = await NavigateTo.push(context, LoginScreenStarter());

    return super
        .navigateConditionally(context, handler, action, data, navigator);
  }
}

class Link {
  String link;

  Link(this.link);
}

class NavResult {}

class OkResult extends NavResult {}

class CancelResult extends NavResult {}

abstract class NavFilters {
  NavResult filterCheck(CurrentNavState state, NavAction action);
}

class NavigationDispather {
  List<NavFilters> filters = [];

  NavigationDispather(this.filters);

  void performNavAction(CurrentNavState state, NavAction action) {
    for (NavFilters filter in filters) {
      NavResult result = filter.filterCheck(state, action);
      if (result is CancelResult) {
        return;
      }
    }
  }
}
