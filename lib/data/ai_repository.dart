import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_ai/data/api_client.dart';

class AIRepository {
  final ApiClient api;
  AIRepository(this.api);

  Future<List<Map<String, dynamic>>> fetchHistory() async {
    final res = await api.dio.get('/api/history/');
    final data = res.data;
    if (data is List) {
      return data.map<Map<String, dynamic>>((e) => (e as Map).cast<String, dynamic>()).toList();
    }
    if (data is Map && data['results'] is List) {
      return (data['results'] as List).map<Map<String, dynamic>>((e) => (e as Map).cast<String, dynamic>()).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> redesignRoom({
    required File originalImage,
    required String styleChoice,
  }) async {
    final form = FormData();
    form.fields.add(MapEntry('style_choice', styleChoice));
    form.files.add(MapEntry(
      'original_image',
      await MultipartFile.fromFile(originalImage.path, filename: originalImage.uri.pathSegments.last),
    ));
    final res = await api.dio.post('/api/redesign-room/', data: form);
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> redesignRoomGuest({
    required File originalImage,
    required String styleChoice,
  }) async {
    final form = FormData();
    form.fields.add(MapEntry('style_choice', styleChoice));
    form.files.add(MapEntry(
      'original_image',
      await MultipartFile.fromFile(originalImage.path, filename: originalImage.uri.pathSegments.last),
    ));
    final res = await api.dio.post('/api/guest/generate/', data: form);
    return (res.data as Map).cast<String, dynamic>();
  }
}
