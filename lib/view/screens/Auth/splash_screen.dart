import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';
import 'package:image_ai/routes/screen_name.dart';
import 'package:image_ai/view/widget/common/fancy_background.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    final auth = Get.find<AuthController>();
    Future.wait([
      auth.ensureHydrated(),
      Future.delayed(const Duration(milliseconds: 1000)), // minimum splash time
    ]).then((_) {
      if (!mounted) return;
      if (auth.isLoggedIn.value) {
        Get.offAllNamed(RoutesName.dashboard);
      } else {
        Get.offAllNamed(RoutesName.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FancyGradientBackground(
      child: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Image.asset(
              'assets/image/app_icon.png',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),



            ),

        ),
      );
  }
}
