import 'dart:io';
import 'package:get/get.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';
import 'package:image_ai/data/ai_repository.dart';

class AIController extends GetxController {
  late final AIRepository repo;
  final history = <Map<String, dynamic>>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final auth = Get.find<AuthController>();
    repo = AIRepository(auth.api);
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      loading.value = true;
      final items = await repo.fetchHistory();
      history.assignAll(items);
      // if (history.isEmpty) {
      //   _injectDummyHistory();
      // }
    } catch (e) {
      Get.snackbar('error'.tr, e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      loading.value = false;
    }
  }

  Future<Map<String, dynamic>> redesignRoom({
    required File originalImage,
    required String styleChoice,
  }) async {
    final res = await repo.redesignRoom(originalImage: originalImage, styleChoice: styleChoice);
    await fetchHistory();
    return res;
  }

  // void _injectDummyHistory() {
  //   final now = DateTime.now();
  //   final fmt = (DateTime d) => d.toIso8601String();
  //   history.assignAll([
  //     {
  //       'output_image_url': 'https://www.thespruce.com/thmb/2_Q52GK3rayV1wnqm6vyBvgI3Ew=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/put-together-a-perfect-guest-room-1976987-hero-223e3e8f697e4b13b62ad4fe898d492d.jpg',
  //       'input_image_url': 'https://www.thespruce.com/thmb/2_Q52GK3rayV1wnqm6vyBvgI3Ew=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/put-together-a-perfect-guest-room-1976987-hero-223e3e8f697e4b13b62ad4fe898d492d.jpg',
  //       'style': 'Modern',
  //       'room_type': 'Living Room',
  //       'created_at': fmt(now.subtract(const Duration(hours: 2))),
  //     },
  //     {
  //       'output_image_url': 'https://picsum.photos/seed/room_out_2/1200/800',
  //       'input_image_url': 'https://picsum.photos/seed/room_in_2/1200/800',
  //       'style': 'Minimalist',
  //       'room_type': 'Bedroom',
  //       'created_at': fmt(now.subtract(const Duration(days: 1, hours: 3))),
  //     },
  //     {
  //       'output_image_url': 'https://picsum.photos/seed/room_out_3/1200/800',
  //       'input_image_url': 'https://picsum.photos/seed/room_in_3/1200/800',
  //       'style': 'Scandinavian',
  //       'room_type': 'Kitchen',
  //       'created_at': fmt(now.subtract(const Duration(days: 3, hours: 6))),
  //     },
  //   ]);
  // }
}
