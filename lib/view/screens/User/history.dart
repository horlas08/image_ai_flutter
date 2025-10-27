import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai/controllers/AI/ai_controller.dart';
import 'package:image_ai/view/screens/User/image_viewer.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'dart:typed_data';

import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = Get.find<AIController>();
    return Obx(() {
      if (ai.loading.value && ai.history.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (ai.history.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('no_history_yet'.tr),
              const SizedBox(height: 8),
              TextButton(onPressed: ai.fetchHistory, child: Text('refresh'.tr)),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () => ai.fetchHistory(),
        child: Column(
          children: [
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: ai.history.length,
              shrinkWrap: true,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final item = ai.history[i];
                final outputUrl = (item['output_image_url'] ?? item['output'] ?? '') as String?;
                final inputUrl = (item['input_image_url'] ?? item['input'] ?? '') as String?;
                final style = (item['style'] ?? '') as String?;
                final roomType = (item['room_type'] ?? '') as String?;
                final created = (item['created_at'] ?? '') as String?;
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (outputUrl != null && outputUrl.isNotEmpty)
                          GestureDetector(
                            onTap: () => Get.to(() => ImageViewer(url: outputUrl)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 1.4,
                                child: Image.network(outputUrl, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        if (created != null && created.isNotEmpty)
                          Text(created, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Row(
                          children: [
                            if (style != null && style.isNotEmpty)
                              Chip(label: Text(style)),
                            const SizedBox(width: 8),
                            if (roomType != null && roomType.isNotEmpty)
                              Chip(label: Text(roomType)),

                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              tooltip: 'download'.tr,
                              icon: const Icon(Icons.download),
                              onPressed: outputUrl == null || outputUrl.isEmpty
                                  ? null
                                  : () async {
                                      try {
                                        // Request permissions if necessary
                                        if (Platform.isIOS) {
                                          final status = await Permission.photosAddOnly.request();
                                          if (!status.isGranted) {
                                            Get.snackbar('permission'.tr, 'photos_permission_required'.tr, snackPosition: SnackPosition.BOTTOM);
                                            return;
                                          }
                                        } else if (Platform.isAndroid) {
                                          final status = await Permission.storage.request();
                                          // On Android 10+ this may be denied but save still works via MediaStore.
                                          // Proceed regardless, unless permanently denied.
                                          if (status.isPermanentlyDenied) {
                                            Get.snackbar('permission'.tr, 'storage_permission_denied'.tr, snackPosition: SnackPosition.BOTTOM);
                                            return;
                                          }
                                        }
                                        final res = await Dio().get<List<int>>(outputUrl, options: Options(responseType: ResponseType.bytes));
                                        final bytes = Uint8List.fromList(res.data ?? []);
                                        if (bytes.isEmpty) throw Exception('failed_to_download'.tr);
                                        final name = 'redesign_${DateTime.now().millisecondsSinceEpoch}';
                                        final result = await ImageGallerySaverPlus.saveImage(bytes, quality: 100, name: name);
                                        final success = (result is Map && (result['isSuccess'] == true || result['filePath'] != null));
                                        if (success) {
                                          Get.snackbar('success'.tr, 'saved_to_gallery'.tr, snackPosition: SnackPosition.BOTTOM);
                                        } else {
                                          throw Exception('save_failed'.tr);
                                        }
                                      } catch (e) {
                                        Get.snackbar('error'.tr, e.toString(), snackPosition: SnackPosition.BOTTOM);
                                      }
                                    },
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: inputUrl == null || inputUrl.isEmpty
                                  ? null
                                  : () => Get.to(() => ImageViewer(url: inputUrl)),
                              icon: const Icon(Icons.image_outlined),
                              label: Text('view_original'.tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          ],
        ),
      );
    });
  }
}
