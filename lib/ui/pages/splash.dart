import 'package:appmoodo/res/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SvgPicture.asset(
            AppAssets.logo,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
