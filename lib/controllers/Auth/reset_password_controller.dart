import 'package:get/get.dart';
import 'package:image_ai/routes/screen_name.dart';

class ResetPasswordController extends GetxController {
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;
  final isSuccess = false.obs;

  void setPassword(String value) {
    password.value = value;
  }

  void setConfirmPassword(String value) {
    confirmPassword.value = value;
  }

  void resetPassword() {
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      isSuccess.value = true;
      
      // Show success message and navigate to login
      Get.snackbar('Success', 'Password reset successfully');
      Get.offAllNamed(RoutesName.login);
    });
  }
}