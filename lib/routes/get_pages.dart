import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';
import 'package:image_ai/routes/screen_name.dart';
import 'package:image_ai/view/screens/Auth/splash_screen.dart';
import 'package:image_ai/view/screens/Auth/login_screen.dart';
import 'package:image_ai/view/screens/Auth/register_screen.dart';
import 'package:image_ai/view/screens/Auth/forgot_password_screen.dart';
import 'package:image_ai/view/screens/Auth/reset_password_screen.dart';
import 'package:image_ai/view/screens/Auth/onboard_screen.dart';
import 'package:image_ai/view/screens/dashboard_screen.dart';

class GetPages {
  static List<GetPage<dynamic>> getPage = [
    GetPage(name: RoutesName.splash, page: () => SplashScreen()),
    GetPage(name: RoutesName.login, page: () => LoginScreen()),
    GetPage(name: RoutesName.register, page: () => RegisterScreen()),
    GetPage(name: RoutesName.forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: RoutesName.resetPassword, page: () => ResetPasswordScreen()),
    GetPage(name: RoutesName.onboard, page: () => OnboardScreen()),
    GetPage(name: RoutesName.dashboard, page: () => DashboardScreen()),
  ];
}

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();

    if (!authController.isLoggedIn.value) {
      return RouteSettings(name: RoutesName.login);
    }
    return null;
  }
}