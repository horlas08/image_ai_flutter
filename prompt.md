# Flutter (Dio + GetX) API Usage Guide

This guide shows how to call the backend APIs using Dio and GetX, including image uploads for profile pictures and room redesign.

## Base Setup

- Base URL: adjust for your environment, e.g. `http://10.0.2.2:8000` (Android emulator) or `http://localhost:8000`.
- JWT auth is used. After login, set the Authorization header for subsequent requests.

```dart
// pubspec.yaml deps
// dio: ^5.x
// get: ^4.x

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ApiClient {
  final Dio dio;
  ApiClient(String baseUrl, {String? accessToken})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Accept': 'application/json',
          },
        )) {
    if (accessToken != null) {
      setToken(accessToken);
    }

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add any common query params/headers here
        return handler.next(options);
      },
      onError: (e, handler) {
        // Handle 401/refresh here if needed
        return handler.next(e);
      },
    ));
  }

  void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
```

## Auth Endpoints

Base path: `/auth/`

- **Register**: `POST /auth/register/`
- **Verify OTP**: `POST /auth/verify-otp/`
- **Login**: `POST /auth/login/`
- **Forgot Password**: `POST /auth/forgot-password/`
- **Reset Password**: `POST /auth/reset-password/`
- **Change Password**: `POST /auth/change-password/` (requires auth)
- **Update Profile**: `PATCH /auth/update-profile/` (multipart, requires auth)

### Register
```dart
Future<void> register(ApiClient api, {
  required String email,
  required String password,
  String? firstName,
  String? lastName,
}) async {
  await api.dio.post('/auth/register/', data: {
    'email': email,
    'password': password,
    'first_name': firstName ?? '',
    'last_name': lastName ?? '',
  });
}
```

### Verify OTP
```dart
Future<void> verifyOtp(ApiClient api, String email, String code) async {
  await api.dio.post('/auth/verify-otp/', data: {
    'email': email,
    'code': code,
  });
}
```

### Login
```dart
class LoginResponse {
  final String access;
  final String refresh;
  final Map<String, dynamic> user;
  LoginResponse(this.access, this.refresh, this.user);
}

Future<LoginResponse> login(ApiClient api, String email, String password) async {
  final res = await api.dio.post('/auth/login/', data: {
    'email': email,
    'password': password,
  });
  final data = res.data as Map<String, dynamic>;
  final access = data['access'] as String;
  final refresh = data['refresh'] as String;
  api.setToken(access);
  return LoginResponse(access, refresh, data['user']);
}
```

### Forgot/Reset Password
```dart
Future<void> forgotPassword(ApiClient api, String email) async {
  await api.dio.post('/auth/forgot-password/', data: {'email': email});
}

Future<void> resetPassword(ApiClient api, {
  required String email,
  required String code,
  required String newPassword,
}) async {
  await api.dio.post('/auth/reset-password/', data: {
    'email': email,
    'code': code,
    'new_password': newPassword,
  });
}
```

### Change Password (auth required)
```dart
Future<void> changePassword(ApiClient api, String oldPassword, String newPassword) async {
  await api.dio.post('/auth/change-password/', data: {
    'old_password': oldPassword,
    'new_password': newPassword,
  });
}
```

### Update Profile (multipart with optional image)
- Fields accepted by backend serializer `UpdateProfileSerializer`: `first_name`, `last_name`, `profile_image`.
- Content type must be `multipart/form-data`.

```dart
Future<Map<String, dynamic>> updateProfile(ApiClient api, {
  String? firstName,
  String? lastName,
  File? profileImage,
}) async {
  final form = FormData();
  if (firstName != null) form.fields.add(MapEntry('first_name', firstName));
  if (lastName != null) form.fields.add(MapEntry('last_name', lastName));
  if (profileImage != null) {
    final fileName = profileImage.path.split('/').last;
    form.files.add(MapEntry(
      'profile_image',
      await MultipartFile.fromFile(profileImage.path, filename: fileName),
    ));
  }
  final res = await api.dio.patch('/auth/update-profile/', data: form);
  return res.data as Map<String, dynamic>;
}
```

## AI Endpoints

Base path: `/api/`

- **Redesign Room**: `POST /api/redesign-room/` (multipart) — fields from `RoomRedesignRequestSerializer`:
  - `original_image` (file)
  - `style_choice` (one of: `modern`, `minimalist`, `luxury`, `industrial`, `scandinavian`)
- **History**: `GET /api/history/` (auth required)

### Redesign Room (multipart with image)
```dart
Future<Map<String, dynamic>> redesignRoom(ApiClient api, {
  required File originalImage,
  required String styleChoice, // e.g. 'modern'
}) async {
  final form = FormData();
  form.fields.add(MapEntry('style_choice', styleChoice));
  final fileName = originalImage.path.split('/').last;
  form.files.add(MapEntry(
    'original_image',
    await MultipartFile.fromFile(originalImage.path, filename: fileName),
  ));

  final res = await api.dio.post('/api/redesign-room/', data: form);
  return res.data as Map<String, dynamic>;
}
```

### History
```dart
Future<List<dynamic>> history(ApiClient api) async {
  final res = await api.dio.get('/api/history/');
  return res.data as List<dynamic>;
}
```

## GetX Controller Example

```dart
class AuthController extends GetxController {
  late ApiClient api;
  final baseUrl = 'http://10.0.2.2:8000';
  final user = Rxn<Map<String, dynamic>>();
  final accessToken = RxnString();

  @override
  void onInit() {
    super.onInit();
    api = ApiClient(baseUrl);
  }

  Future<void> doLogin(String email, String password) async {
    final resp = await login(api, email, password);
    accessToken.value = resp.access;
    user.value = resp.user;
  }

  Future<void> doUpdateProfile({String? firstName, String? lastName, File? image}) async {
    await updateProfile(api, firstName: firstName, lastName: lastName, profileImage: image);
    // Optionally refresh current user from token or a user endpoint if available
  }
}
```

## Notes

- For Android emulator, use `10.0.2.2` to reach the host machine. For iOS simulator, use `http://localhost`.
- The backend serves media at `/media/`. Profile images and generated images are saved on the server and exposed via `MEDIA_URL`.
- Swagger UI at `/docs/` will show file pickers for `profile_image` and `original_image` thanks to multipart schema annotations.
- Ensure `OPENAI_API_KEY` is set in server environment.
