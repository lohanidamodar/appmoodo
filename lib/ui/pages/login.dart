import 'package:appmoodo/res/app_colors.dart';
import 'package:appmoodo/res/assets.dart';
import 'package:appmoodo/service/api_service.dart';
import 'package:appmoodo/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

final emailControllerProvider =
    Provider<TextEditingController>((ref) => TextEditingController());
final passwordControllerProvider =
    Provider<TextEditingController>((ref) => TextEditingController());

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Card(
                    color: AppColors.primaryColor,
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 10,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
                  child: SvgPicture.asset(AppAssets.logo, color: Colors.white),
                ),
                Text(
                  "Moodo",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 20.0),
                Card(
                  margin: const EdgeInsets.all(32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const SizedBox(height: 20.0),
                      Text(
                        "Log In",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: watch(emailControllerProvider),
                        decoration: InputDecoration(
                          labelText: "Enter email",
                        ),
                      ),
                      TextField(
                        controller: watch(passwordControllerProvider),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Enter password",
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        child: Text("Login"),
                        onPressed: () async {
                          context.read(authStateProvider).state =
                              AuthStatus.authenticating;
                          final loggedIn = await ApiService.instance!.login(
                              email: context.read(emailControllerProvider).text,
                              password: context
                                  .read(passwordControllerProvider)
                                  .text);
                          if (loggedIn) {
                            final user = await ApiService.instance!.getUser();
                            context.read(userProvider).state = user;
                            context.read(authStateProvider).state =
                                AuthStatus.authenticated;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextButton(
                        child: Text(
                          "New user? Register",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: AppColors.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, 'signup');
                        },
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
