import 'package:dio/dio.dart';
import 'api_client.dart';
import 'dart:io';

class LoginResponse {
  final String access;
  final String refresh;
  final Map<String, dynamic> user;
  LoginResponse(this.access, this.refresh, this.user);
}

class AuthRepository {
  final ApiClient api;
  AuthRepository(this.api);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final res = await api.dio.post('/auth/login/', data: {
        'email': email,
        'password': password,
      });
      print(res);
      final data = res.data as Map<String, dynamic>;
      return LoginResponse(
        data['access'] as String,
        data['refresh'] as String,
        (data['user'] as Map).cast<String, dynamic>(),
      );
    } on DioException catch (e) {
      throw Exception(_friendlyMessage(e));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? username,
  }) async {
    try {
      await api.dio.post('/auth/register/', data: {
        'email': email,
        'password': password,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (username != null && username.isNotEmpty) 'username': username,
      });
    } on DioException catch (e) {
      throw Exception(_friendlyMessage(e));
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await api.dio.post('/auth/forgot-password/', data: {'email': email});
    } on DioException catch (e) {
      throw Exception(_friendlyMessage(e));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await api.dio.post('/auth/reset-password/', data: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw Exception(_friendlyMessage(e));
    }
  }

  Future<String?> refreshToken(String refreshToken) async {
    try {
      final res = await api.dio.post('/auth/refresh/', data: {
        'refresh': refreshToken,
      });
      final data = res.data as Map<String, dynamic>;
      return data['access'] as String?;
    } on DioException {
      // Returning null signals the caller to handle re-authentication
      return null;
    }
  }

  String _friendlyMessage(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    // Try common shapes: {detail: ...} or {message: ...} or field errors map
    String? serverMsg;
    if (data is Map) {
      if (data['detail'] is String) serverMsg = data['detail'] as String;
      else if (data['message'] is String) serverMsg = data['message'] as String;
      else {
        // Aggregate first string from field errors
        final parts = <String>[];
        data.forEach((k, v) {
          if (v is List && v.isNotEmpty) parts.add(v.first.toString());
          else if (v is String) parts.add(v);
        });
        if (parts.isNotEmpty) serverMsg = parts.join('\n');
      }
    } else if (data is String) {
      serverMsg = data;
    }

    if (serverMsg != null && serverMsg.trim().isNotEmpty) return serverMsg.trim();

    switch (status) {
      case 400:
        return 'Invalid request. Please check the details and try again.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden. You don\'t have access to perform this action.';
      case 404:
        return 'Not found. Please try again later.';
      case 422:
        return 'Validation failed. Please review the form and try again.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return e.message ?? 'Network error. Please check your connection.';
    }
  }

  Future<Map<String, dynamic>> updateProfile({String? firstName, String? lastName, File? profileImage}) async {
    try {
      final form = FormData();
      if (firstName != null) form.fields.add(MapEntry('first_name', firstName));
      if (lastName != null) form.fields.add(MapEntry('last_name', lastName));
      if (profileImage != null) {
        form.files.add(MapEntry(
          'profile_image',
          await MultipartFile.fromFile(profileImage.path, filename: profileImage.uri.pathSegments.last),
        ));
      }
      final res = await api.dio.patch('/auth/update-profile/', data: form);
      final data = res.data as Map<String, dynamic>;
      // Expect either entire user or { user: {...} }
      if (data['user'] is Map) return (data['user'] as Map).cast<String, dynamic>();
      return data.cast<String, dynamic>();
    } on DioException catch (e) {
      throw Exception(_friendlyMessage(e));
    }
  }

  Future<Map<String, dynamic>> uploadAvatar(File file) async {
    return updateProfile(profileImage: file);
  }

  Future<void> changePassword({required String oldPassword, required String newPassword}) async {
    try {
      await api.dio.post('/auth/change-password/', data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw Exception(_friendlyMessage(e));
    }
  }
}
