import 'package:appmoodo/res/app_colors.dart';
import 'package:appmoodo/service/api_service.dart';
import 'package:appmoodo/state/state.dart';
import 'package:appmoodo/ui/pages/add.dart';
import 'package:appmoodo/ui/pages/home.dart';
import 'package:appmoodo/ui/pages/login.dart';
import 'package:appmoodo/ui/pages/profile.dart';
import 'package:appmoodo/ui/pages/signup.dart';
import 'package:appmoodo/ui/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'res/app_colors.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getUser();
  }

  _getUser() async {
    await Future.delayed(Duration.zero);
    context.read(authStateProvider).state = AuthStatus.authenticating;
    final user = await ApiService.instance!.getUser();
    if (user != null) {
      context.read(userProvider).state = user;
      context.read(authStateProvider).state = AuthStatus.authenticated;
    } else {
      context.read(authStateProvider).state = AuthStatus.unauthenticated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppMoodo',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: AppColors.primaryColor,
          ),
          textTheme: TextTheme(
            headline6: TextStyle(
              inherit: true,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
      home: AuthChecker(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) {
          switch (settings.name) {
            case 'login':
              return LoginPage();
            case 'signup':
              return SignupPage();
            case 'add':
              return AddMoodPage();
            case 'profile':
              return ProfilePage();
            case 'chat':
            default:
              return HomePage();
          }
        });
      },
    );
  }
}

class AuthChecker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authStatus = watch(authStateProvider).state;
    return authStatus == AuthStatus.authenticated
        ? HomePage()
        : authStatus == AuthStatus.authenticating ||
                authStatus == AuthStatus.uninitialized
            ? SplashScreen()
            : LoginPage();
  }
}
