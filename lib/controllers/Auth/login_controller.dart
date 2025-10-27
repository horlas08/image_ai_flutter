import 'package:get/get.dart';
import 'package:image_ai/routes/screen_name.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void login() {
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      
      // For demo purposes, we'll just navigate to dashboard
      Get.offAllNamed(RoutesName.dashboard);
    });
  }

  void navigateToRegister() {
    Get.toNamed(RoutesName.register);
  }

  void navigateToForgotPassword() {
    Get.toNamed(RoutesName.forgotPassword);
  }
}