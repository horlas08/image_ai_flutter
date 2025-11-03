import 'dart:io';
import 'package:get/get.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';
import 'package:image_ai/data/ai_repository.dart';
import 'package:image_ai/data/token_storage.dart';

class AIController extends GetxController {
  late final AIRepository repo;
  final history = <Map<String, dynamic>>[].obs;
  final loading = false.obs;
  final _storage = TokenStorage();

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
      final auth = Get.find<AuthController>();
      if (auth.isLoggedIn.value) {
        final items = await repo.fetchHistory();
        history.assignAll(items);
      } else {
        final local = await _storage.getGuestHistory();
        history.assignAll(local);
      }
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
    final auth = Get.find<AuthController>();
    if (auth.isLoggedIn.value) {
      final res = await repo.redesignRoom(originalImage: originalImage, styleChoice: styleChoice);
      await fetchHistory();
      return res;
    } else {
      // Guest generation (server optional). If server not available, you can mock/store locally.
      try {
        final res = await repo.redesignRoomGuest(originalImage: originalImage, styleChoice: styleChoice);
        // Append to local history and persist
        final local = await _storage.getGuestHistory();
        local.insert(0, res);
        await _storage.saveGuestHistory(local);
        await fetchHistory();
        return res;
      } catch (e) {
        rethrow;
      }
    }
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
