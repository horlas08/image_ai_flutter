import 'package:get/get.dart';
import 'package:image_ai/routes/screen_name.dart';

class OnboardController extends GetxController {
  final currentPage = 0.obs;

  void nextPage() {
    if (currentPage.value < 2) { // Assuming 3 onboard screens
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  void navigateToLogin() {
    Get.offAllNamed(RoutesName.login);
  }

  void navigateToRegister() {
    Get.offAllNamed(RoutesName.register);
  }
}