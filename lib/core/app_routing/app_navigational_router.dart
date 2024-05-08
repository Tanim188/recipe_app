import 'package:flutter/material.dart';
import 'package:receipe_app/core/app_routing/route_names.dart';

import '../../app/authentication/presentation/pages/authentication_page.dart';
import '../../app/recipe_app/presentation/homepage.dart';

class AppNavigationalRouter {
  //
  static Route<dynamic>? handleAppNavigatorRouting(RouteSettings settings) {
    late final Widget widget;

    switch (settings.name) {
      case RecipeRouteName.authenticationPage:
        widget = const AuthenticationPage();
        break;
      // case RecipeRouteName.homepage:
      //   // final email = (settings.arguments as Map);
      //   // widget = RecipeHomepage(email: email["email"]);
      //   widget = const RecipeHomepage(
      //     email: "test@gmail.nothing",
      //   );
      //   break;
    }
    return _routeTo(
      routeWidget: widget,
      settings: settings,
    );
  }

  static Route _routeTo({
    required Widget routeWidget,
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => routeWidget,
      allowSnapshotting: false,
    );
  }
}
