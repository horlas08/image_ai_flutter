import 'package:get/get.dart';
import 'package:image_ai/routes/screen_name.dart';

class ForgotPasswordController extends GetxController {
  final email = ''.obs;
  final isLoading = false.obs;
  final isSuccess = false.obs;

  void setEmail(String value) {
    email.value = value;
  }

  void sendResetLink() {
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      isSuccess.value = true;
      
      // Show success message
      Get.snackbar('Success', 'Password reset link sent to your email');
    });
  }

  void navigateToLogin() {
    Get.toNamed(RoutesName.login);
  }
}