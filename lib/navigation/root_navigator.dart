import "package:flutter/material.dart";
import 'package:flutter_navigation/screens/screen_one/screen_one.dart';
import 'package:flutter_navigation/screens/screen_three/login_screen.dart';
import 'package:provider/provider.dart';

class NavRoot extends StatefulWidget {
  final Link initialLink;
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
  Link startLink;

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
      ],
      child: MaterialApp(
        navigatorObservers: [observer],
        navigatorKey: key,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: buildDefaultHomeContent(),
      ),
    );
  }

  Widget buildDefaultHomeContent() => ScreenOne();

  @override
  Future<Result> navigate<Data, Result>(BuildContext ctx,
      NavigationHandler<Data, dynamic> navigate, RoutingMethod<Result> action,
      [Data data]) async {
    RouteAction canRoute = await navigate.canRoute(ctx, _navState);
    return canRoute.navigateConditionally(
        ctx, navigate, action, data, key.currentState);
  }
}

class NavObserver extends NavigatorObserver {
  final _NavRootState _navRootState;

  NavObserver(this._navRootState);

  @override
  void didPush(Route route, Route previousRoute) {
    _navRootState._navState.last = route;
  }
}

abstract class NavDelegate {
  Future<Result> navigate<Data, Result>(BuildContext ctx,
      NavigationHandler<Data, dynamic> navigate, RoutingMethod<Result> action,
      [Data data]);
}

class CurrentNavState {
  Route last;
}

class NavigateTo {
  static Future<Result> push<Data, Result>(
      BuildContext ctx, NavigationHandler<Data, Result> handler,
      [Data data]) {
    return Provider.of<NavDelegate>(ctx, listen: false)
        .navigate<Data, Result>(ctx, handler, NavigatePush(), data);
  }

  static Future<Result> replace<Data, Result>(
      BuildContext ctx, NavigationHandler<Data, Result> handler,
      [Data data]) {
    return Provider.of<NavDelegate>(ctx, listen: false)
        .navigate<Data, Result>(ctx, handler, NavigateReplace(), data);
  }
}

abstract class NavigationHandler<Data, Result> {
  Future<RouteAction<Result>> canRoute(
          BuildContext ctx, CurrentNavState state) async =>
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
    final data = await NavigateTo.push(context, LoginScreenStarter());

    return super
        .navigateConditionally(context, handler, action, data, navigator);
  }
}

class Link {}
