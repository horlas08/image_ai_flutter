import 'package:dio/dio.dart';

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
        ));

  void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
