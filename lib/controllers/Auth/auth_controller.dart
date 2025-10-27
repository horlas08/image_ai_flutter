import 'package:get/get.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_ai/config/env.dart';
import 'package:image_ai/data/api_client.dart';
import 'package:image_ai/data/auth_repository.dart';
import 'package:image_ai/data/token_storage.dart';
import 'package:image_ai/models/user_model.dart';
import 'package:image_ai/routes/screen_name.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxnString access = RxnString();
  final RxnString refreshAuth = RxnString();

  late final ApiClient api;
  late final AuthRepository repo;
  final TokenStorage storage = TokenStorage();
  final Completer<void> _hydration = Completer<void>();

  @override
  void onInit() {
    super.onInit();
    api = ApiClient(Env.baseUrl);
    repo = AuthRepository(api);

    _setupInterceptors();
    _hydrate();
  }

  void _setupInterceptors() {
    api.dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Ensure Authorization header is present for every request if token exists
        final token = access.value;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        // Do not attempt refresh on auth endpoints
        final path = e.requestOptions.path;
        final isAuthEndpoint = path.startsWith('/auth/');
        if (e.response?.statusCode == 401 && !isAuthEndpoint) {
          final ok = await tryRefresh();
          if (ok) {
            try {
              final req = e.requestOptions;
              // attach fresh token header to the original request
              final token = access.value;
              if (token != null && token.isNotEmpty) {
                req.headers['Authorization'] = 'Bearer $token';
              } else {
                req.headers.remove('Authorization');
              }
              final cloned = await api.dio.fetch(req);
              return handler.resolve(cloned);
            } catch (_) {}
          }
          // Refresh failed, logout and redirect to login
          await logout();
          Get.offAllNamed(RoutesName.login);
          Get.snackbar('error'.tr, 'session_expired'.tr, snackPosition: SnackPosition.BOTTOM);
          return;
        }
        return handler.next(e);
      },
    ));
  }

  Future<void> _hydrate() async {
    final savedAccess = await storage.getAccessToken();
    final savedRefresh = await storage.getRefreshToken();
    final savedUser = await storage.getUser();
    if (savedAccess != null && savedRefresh != null) {
      access.value = savedAccess;
      refreshAuth.value = savedRefresh;
      api.setToken(savedAccess);
      if (savedUser != null) {
        user.value = UserModel.fromMap(savedUser);
      }
      isLoggedIn.value = true;
    }
    if (!_hydration.isCompleted) _hydration.complete();
  }

  Future<bool> login(String email, String password) async {
    // Ensure we don't send stale Authorization when logging in
    api.dio.options.headers.remove('Authorization');
    final resp = await repo.login(email, password);
    access.value = resp.access;
    refreshAuth.value = resp.refresh;
    final typed = UserModel.fromMap(resp.user);
    user.value = typed;
    api.setToken(resp.access);
    await storage.saveTokens(resp.access, resp.refresh);
    await storage.saveUser(typed.toMap());
    isLoggedIn.value = true;
    return true;
  }

  Future<void> forgotPassword(String email) => repo.forgotPassword(email);

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => repo.resetPassword(email: email, code: code, newPassword: newPassword);

  Future<bool> tryRefresh() async {
    final r = refreshAuth.value ?? await storage.getRefreshToken();
    if (r == null) return false;
    final newAccess = await repo.refreshToken(r);
    if (newAccess == null) {
      await logout();
      return false;
    }
    access.value = newAccess;
    api.setToken(newAccess);
    await storage.saveTokens(newAccess, r);
    isLoggedIn.value = true;
    return true;
  }

  Future<void> logout() async {
    await storage.clear();
    isLoggedIn.value = false;
    access.value = null;
    refreshAuth.value = null;
    user.value = null;
    // Remove any stale Authorization header from Dio
    api.dio.options.headers.remove('Authorization');
  }

  Future<void> ensureHydrated() async {
    return _hydration.future;
  }

  Future<void> updateProfile({required String firstName, required String lastName}) async {
    try {
      final updated = await repo.updateProfile(firstName: firstName, lastName: lastName);
      final typed = UserModel.fromMap(updated);
      user.value = typed;
      await storage.saveUser(typed.toMap());
      Get.snackbar('success'.tr, 'profile_updated'.tr, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('update_failed'.tr, e.toString().replaceFirst('Exception: ', ''), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> uploadAvatar(File file) async {
    try {
      final updated = await repo.uploadAvatar(file);
      final typed = UserModel.fromMap(updated);
      user.value = typed;
      await storage.saveUser(typed.toMap());
      Get.snackbar('success'.tr, 'profile_image_updated'.tr, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('upload_failed'.tr, e.toString().replaceFirst('Exception: ', ''), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> changePassword({required String oldPassword, required String newPassword}) async {
    try {
      await repo.changePassword(oldPassword: oldPassword, newPassword: newPassword);
      Get.snackbar('success'.tr, 'password_changed_successfully'.tr, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('change_password_failed'.tr, e.toString().replaceFirst('Exception: ', ''), snackPosition: SnackPosition.BOTTOM);
      rethrow;
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
      await repo.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        username: username,
      );
      Get.snackbar('success'.tr, 'account_created_please_login'.tr, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('error'.tr, e.toString().replaceFirst('Exception: ', ''), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }
}