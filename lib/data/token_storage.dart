import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class TokenStorage {
  static const _keyAccess = 'access_token';
  static const _keyRefresh = 'refresh_token';
  static const _keyUser = 'user_json';
  static const _keyIsPro = 'is_pro';
  static const _keyGuestHistory = 'guest_history_json';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: _keyAccess, value: access);
    await _storage.write(key: _keyRefresh, value: refresh);
  }

  Future<String?> getAccessToken() => _storage.read(key: _keyAccess);
  Future<String?> getRefreshToken() => _storage.read(key: _keyRefresh);

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: _keyUser, value: jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final raw = await _storage.read(key: _keyUser);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return decoded.cast<String, dynamic>();
    } catch (_) {}
    return null;
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
    await _storage.delete(key: _keyUser);
    await _storage.delete(key: _keyIsPro);
    await _storage.delete(key: _keyGuestHistory);
  }

  Future<void> saveIsPro(bool value) async {
    await _storage.write(key: _keyIsPro, value: value ? '1' : '0');
  }

  Future<bool> getIsPro() async {
    final v = await _storage.read(key: _keyIsPro);
    return v == '1';
  }

  Future<void> saveGuestHistory(List<Map<String, dynamic>> items) async {
    await _storage.write(key: _keyGuestHistory, value: jsonEncode(items));
  }

  Future<List<Map<String, dynamic>>> getGuestHistory() async {
    final raw = await _storage.read(key: _keyGuestHistory);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map<Map<String, dynamic>>((e) => e.cast<String, dynamic>())
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
