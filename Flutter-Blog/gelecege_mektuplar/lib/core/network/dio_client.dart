import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gelecege_mektuplar/core/constants/api_constants.dart';
import 'package:gelecege_mektuplar/data/repositories/auth_repository.dart';

/// Dio istemcisini sağlamak için Riverpod provider'ı.
/// Bu provider, API istekleri için yapılandırılmış bir Dio nesnesi oluşturur.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: 'application/json',
    ),
  );

  // API isteklerine ve yanıtlarına müdahale etmek için interceptor ekleniyor.
  dio.interceptors.add(
    InterceptorsWrapper(
      // Her istek gönderilmeden önce bu fonksiyon çalışır.
      onRequest: (options, handler) async {
        // SharedPreferences'tan token'ı al.
        // AuthRepository'deki provider'ı kullanıyoruz.
        final prefs = await ref.read(sharedPreferencesProvider.future);
        final token = prefs.getString('jwt_token');

        // Eğer token varsa, Authorization başlığına ekle.
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        // İsteği devam ettir.
        return handler.next(options);
      },
      // Bir hata oluştuğunda bu fonksiyon çalışır.
      onError: (DioException e, handler) {
        // Backend'den gelen hata mesajını ayıkla.
        // Yanıtın datası bir Map ise ve 'message' anahtarı içeriyorsa,
        // bu mesajı DioException'ın error alanına ata.
        // Bu, UI katmanında daha anlaşılır hata mesajları göstermemizi sağlar.
        if (e.response?.data is Map<String, dynamic>) {
          final message = e.response?.data['message'];
          if (message != null) {
            // Hata nesnesini daha anlamlı bir mesajla değiştiriyoruz.
            final newError = DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
              error: message, // Anlaşılır hata mesajını buraya koyuyoruz.
            );
            return handler.next(newError);
          }
        }
        // Hata üzerinde bir değişiklik yapmadan devam et.
        return handler.next(e);
      },
    ),
  );

  return dio;
});
