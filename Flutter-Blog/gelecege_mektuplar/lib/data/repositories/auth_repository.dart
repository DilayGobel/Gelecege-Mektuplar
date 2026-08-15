import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gelecege_mektuplar/core/constants/api_constants.dart';
import 'package:gelecege_mektuplar/core/network/dio_client.dart';
import 'package:gelecege_mektuplar/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

/// AuthRepository'yi sağlamak için Riverpod provider'ı.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(dio: ref.watch(dioProvider), ref: ref);
});

class AuthRepository {
  final Dio _dio;
  final Ref _ref;

  AuthRepository({required this._dio, required Ref ref}) : _ref = ref;

  /// Kullanıcı kaydı yapar.
  /// Başarılı olursa token'ı saklar ve [UserModel] döndürür.
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {'username': username, 'email': email, 'password': password},
      );

      final token = response.data['token'] as String;
      final prefs = await _ref.read(sharedPreferencesProvider.future);
      await prefs.setString('jwt_token', token);

      // Backend, kullanıcı bilgilerini 'user' anahtarı altında bir nesne olarak gönderiyor.
      final userData = response.data['user'] as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      // Interceptor zaten backend'den gelen mesajı e.error'a atıyor.
      // Bu yüzden doğrudan e.error'u fırlatmak yeterli.
      // Eğer e.error null ise, genel bir mesaj fırlat.
      throw e.error?.toString() ??
          'Kayıt işlemi sırasında bilinmeyen bir hata oluştu.';
    } catch (e) {
      throw 'Bilinmeyen bir hata oluştu.';
    }
  }

  /// Kullanıcı girişi yapar.
  /// Başarılı olursa token'ı saklar ve [UserModel] döndürür.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'] as String;
      final prefs = await _ref.read(sharedPreferencesProvider.future);
      await prefs.setString('jwt_token', token);

      // Backend, kullanıcı bilgilerini 'user' anahtarı altında bir nesne olarak gönderiyor.
      final userData = response.data['user'] as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      // Interceptor zaten backend'den gelen mesajı e.error'a atıyor.
      // Bu yüzden doğrudan e.error'u fırlatmak yeterli.
      // Eğer e.error null ise, genel bir mesaj fırlat.
      throw e.error?.toString() ??
          'Giriş işlemi sırasında bilinmeyen bir hata oluştu.';
    } catch (e) {
      throw 'Bilinmeyen bir hata oluştu.';
    }
  }

  /// Kullanıcı oturumunu sonlandırır.
  Future<void> logout() async {
    try {
      final prefs = await _ref.read(sharedPreferencesProvider.future);
      await prefs.remove('jwt_token');
    } catch (e) {
      // Genellikle bu işlem hata vermez ama verirse loglamak iyi olabilir.
      throw 'Çıkış yaparken bir sorun oluştu.';
    }
  }

  /// Mevcut token'ı kontrol ederek oturum durumunu doğrular.
  /// Token geçerliyse ve bir kullanıcı bilgisi alınabiliyorsa UserModel döner.
  Future<String?> getAuthToken() async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    return prefs.getString('jwt_token');
  }

  /// Saklanan token ile mevcut kullanıcı bilgisini getirir.
  /// Token yoksa veya geçersizse null döner.
  Future<UserModel?> getMe() async {
    try {
      final token = await getAuthToken();
      if (token == null) {
        return null;
      }
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      // Token geçersizse veya başka bir ağ hatası olursa,
      // interceptor token'ı siler ve biz de null döneriz.
      await logout();
      return null;
    } catch (e) {
      await logout();
      return null;
    }
  }
}
