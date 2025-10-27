import 'package:get/get.dart';
import 'package:image_ai/routes/screen_name.dart';

class RegisterController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;

  void setName(String value) {
    name.value = value;
  }

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void setConfirmPassword(String value) {
    confirmPassword.value = value;
  }

  void register() {
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      
      // For demo purposes, we'll just navigate to dashboard
      Get.offAllNamed(RoutesName.dashboard);
    });
  }

  void navigateToLogin() {
    Get.toNamed(RoutesName.login);
  }
}