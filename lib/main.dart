import 'package:appmoodo/service/api_service.dart';
import 'package:appmoodo/state/state.dart';
import 'package:appmoodo/ui/pages/home.dart';
import 'package:appmoodo/ui/pages/login.dart';
import 'package:appmoodo/ui/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  void initState() {
    super.initState();
    _getUser();
  }

  _getUser() async {
    final user = await ApiService.instance.getUser();
    if (user != null) {
      context.read(userProvider).state = user;
      context.read(isLoggedInProvider).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthChecker(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) {
          switch (settings.name) {
            case 'login':
              return LoginPage();
            // case 'signup':
            //   return SignupPage();
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
    final isLoggedIn = watch(isLoggedInProvider).state;
    return isLoggedIn ? HomePage() : LoginPage();
  }
}
