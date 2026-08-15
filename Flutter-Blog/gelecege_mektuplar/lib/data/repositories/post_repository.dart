import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gelecege_mektuplar/core/constants/api_constants.dart';
import 'package:gelecege_mektuplar/core/network/dio_client.dart';
import 'package:gelecege_mektuplar/data/models/post_model.dart';

/// PostRepository'yi sağlamak için Riverpod provider'ı.
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(dio: ref.watch(dioProvider));
});

class PostRepository {
  final Dio _dio;

  PostRepository({required this._dio});

  /// Gönderileri getirir. Arama ve kategoriye göre filtreleme yapılabilir.
  Future<List<PostModel>> getPosts({String? search, String? category}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (category != null && category.isNotEmpty) {
        queryParameters['category'] = category;
      }

      final response = await _dio.get(
        ApiConstants.posts,
        queryParameters: queryParameters,
      );

      // Backend'den gelen yanıt bir nesne ve post'lar 'posts' anahtarı altında bir liste.
      final responseData = response.data as Map<String, dynamic>;
      final List<dynamic> data = responseData['posts'] as List<dynamic>;
      return data
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error ?? 'Gönderileri getirirken bir hata oluştu.';
    } catch (e) {
      throw 'Bilinmeyen bir hata oluştu.';
    }
  }

  /// ID'ye göre tek bir gönderi getirir.
  Future<PostModel> getPostById(String id) async {
    try {
      final response = await _dio.get(ApiConstants.postById(id));
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error ?? 'Gönderi detayını getirirken bir hata oluştu.';
    } catch (e) {
      throw 'Bilinmeyen bir hata oluştu.';
    }
  }

  /// Yeni bir gönderi oluşturur.
  Future<void> createPost({
    required String title,
    required String content,
    required String category,
  }) async {
    try {
      await _dio.post(
        ApiConstants.posts,
        data: {'title': title, 'content': content, 'category': category},
        // Backend boş yanıt döndüğü için (201 Created), Dio'nun JSON parse hatası vermesini önlüyoruz.
        // Yanıtın düz metin olarak ele alınmasını sağlıyoruz.
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (e) {
      throw e.error ?? 'Gönderi oluşturulurken bir hata oluştu.';
    } catch (e) {
      throw 'Bilinmeyen bir hata oluştu.';
    }
  }

  /// ID'ye göre bir gönderiyi günceller.
  Future<void> updatePost(
    String id, {
    required String title,
    required String content,
    required String category,
  }) async {
    try {
      await _dio.put(
        ApiConstants.postById(id),
        data: {'title': title, 'content': content, 'category': category},
        // Backend boş bir yanıt (200 OK) döndüğü için, Dio'nun varsayılan olarak
        // JSON parse etmeye çalışıp hata vermesini önlemek amacıyla yanıt türünü 'plain' olarak ayarlıyoruz.
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (e) {
      // Interceptor'ın responseType: plain nedeniyle JSON'u ayrıştıramadığı durumlar için
      // doğrudan response.data'yı kontrol edip fırlatıyoruz.
      // Bu, backend'den gelen spesifik hata mesajlarını (örn: "Yetkiniz yok") yakalamamızı sağlar.
      throw e.response?.data ??
          e.error ??
          'Gönderi güncellenirken bir hata oluştu.';
    } catch (e) {
      throw 'Bilinmeyen bir hata oluştu.';
    }
  }

  /// ID'ye göre bir gönderiyi siler.
  Future<void> deletePost(String id) async {
    try {
      await _dio.delete(
        ApiConstants.postById(id),
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (e) {
      throw e.error ?? 'Gönderi silinirken bir hata oluştu.';
    } catch (e) {
      throw 'Bilinmeyen bir hata oluştu.';
    }
  }
}
