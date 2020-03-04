import 'package:flutter/material.dart';
import 'package:flutter_navigation/navigation/custom_navigator.dart';
import 'package:flutter_navigation/navigation/root_navigator.dart';
import 'package:flutter_navigation/screens/screen_three/login_screen.dart';

class AuthFilter extends NavigationFilter {
  @override
  NavResult canActivate(
    NavigatorState navigator,
    BuildContext context,
    CurrentNavState state,
    Route action,
  ) {
    if (action is AttributeMaterialPageRoute) {
      AttributeMaterialPageRoute attributeRoute = action;
      for (dynamic attribute in attributeRoute.attributes) {
        if (attribute == "Auth" && !state.isLoggedIn) {
          navigator.pushAndRemoveUntil(
              LoginScreen.route(attributeRoute), (route) => false);
          return CancelResult();
        }
      }
    }
    return OkResult();
  }
}
