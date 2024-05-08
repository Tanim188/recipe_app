import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'app/authentication/presentation/pages/authentication_page.dart';
import 'app/recipe_app/presentation/homepage.dart';
import 'app/recipe_app/providers/refresh_provider.dart';
import 'app/recipe_app/providers/search_bar_provider.dart';
import 'core/app_routing/app_navigational_router.dart';
import 'core/framework_specific/app_scrolling_behaviour.dart';
import 'core/local_db/box_names.dart';
import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init(null);
  await Hive.openBox(HiveBoxName.signupBox);
  await Hive.openBox(HiveBoxName.foodRecipeStoreBox);
  await Hive.openBox(HiveBoxName.sessionStatePersistentStoreBox);
  configLoading();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Application',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const RecipeHomepage(
      //   email: 'test@gmail',
      // ),
      home: const SessionMonitor(),
      // onGenerateRoute: AppNavigationalRouter.handleAppNavigatorRouting,
      scrollBehavior: CustomScrollBehavior(),
    );
  }
}

class SessionMonitor extends StatefulWidget {
  const SessionMonitor({super.key});

  @override
  State<SessionMonitor> createState() => _SessionMonitorState();
}

class _SessionMonitorState extends State<SessionMonitor> {
  @override
  void initState() {
    super.initState();
    print("SessionMonitor page: ");
  }

  @override
  Widget build(BuildContext context) {
    final signupBox = Hive.box(HiveBoxName.signupBox);
    for (final email in signupBox.keys) {
      final userMapData = signupBox.get(email);
      if (userMapData["isLogout"] == "true") {
        // user is login already
        print("User email: $email is already login");

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<SearchBarProvider>(
              create: (context) => SearchBarProvider(),
            ),
            // ChangeNotifierProvider<RefreshProvider>(
            //   create: (context) => RefreshProvider(),
            // ),
          ],
          child: RecipeHomepage(email: email),
        );
        // return RecipeHomepage(email: email);
        // ---
        // return Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return RecipeHomepage(email: email);
        //     },
        //   ),
        // );
      } else {
        // no session found

        // return Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return const AuthenticationPage();
        //     },
        //   ),
        // );
      }
    }
    return const AuthenticationPage();
    // return const SizedBox();
    // return const AuthenticationPage();
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 15.0
    ..progressColor = Colors.white
    ..backgroundColor = AppColor.primaryColor
    ..indicatorColor = AppColor.onPrimaryColor
    ..textColor = AppColor.onPrimaryColor
    ..maskColor = AppColor.primaryColor.withOpacity(0.3)
    ..userInteractions = false
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}
