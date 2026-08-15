import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;

/// API ve endpoint sabitlerini barındıran sınıf.
/// Bu sınıfın örneği oluşturulamaz.
final class ApiConstants {
  ApiConstants._();

  /// Uygulamanın çalışma moduna göre (Debug/Release) API'nin temel URL'sini döndürür.
  static String get baseUrl {
    // Eğer uygulama 'release' modunda derlendiyse, canlı sunucu adresini kullan.
    if (kReleaseMode) {
      // TODO: Backend'i canlıya aldığında bu adresi kendi sunucu adresinle değiştir.
      return 'https://api.gelecegemektuplar.com/api';
    }
    // Eğer uygulama 'debug' modunda çalışıyorsa, yerel sunucu adresini kullan.
    else {
      // Geliştirme sırasında hem emülatör hem de fiziksel cihazdan erişim için
      // bilgisayarının yerel ağ IP adresini kullan.
      return 'http://192.168.1.107:5000/api';
    }
  }

  // --- Auth Endpoints ---
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // --- Posts Endpoints ---
  static const String posts = '/posts'; // GET (all), POST
  static String postById(String id) => '/posts/$id'; // GET (single), DELETE
}
