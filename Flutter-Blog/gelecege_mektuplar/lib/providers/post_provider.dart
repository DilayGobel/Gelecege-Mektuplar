import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gelecege_mektuplar/data/models/post_model.dart';
import 'package:gelecege_mektuplar/data/repositories/post_repository.dart';

/// ID'ye göre tek bir gönderinin detayını getiren provider.
final postDetailProvider = FutureProvider.family<PostModel, String>((ref, id) {
  final postRepository = ref.watch(postRepositoryProvider);
  return postRepository.getPostById(id);
});

/// PostNotifier'ı sağlamak için Riverpod AsyncNotifierProvider'ı.
final postsProvider = AsyncNotifierProvider<PostNotifier, List<PostModel>>(() {
  return PostNotifier();
});

class PostNotifier extends AsyncNotifier<List<PostModel>> {
  @override
  Future<List<PostModel>> build() {
    // Repository'yi build metodu dışında, doğrudan ref üzerinden okuyarak alalım.
    final postRepository = ref.watch(postRepositoryProvider);
    return postRepository.getPosts();
  }

  /// Gönderileri getirir veya mevcut listeyi günceller.
  /// Arama ve kategoriye göre filtreleme yapılabilir.
  Future<void> fetchPosts({String? search, String? category}) async {
    state = const AsyncValue.loading();
    final postRepository = ref.read(postRepositoryProvider);
    try {
      final posts = await postRepository.getPosts(
        search: search,
        category: category,
      );
      state = AsyncValue.data(posts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Gönderi listesini yeniden yükler (pull-to-refresh gibi).
  Future<void> refreshPosts() async {
    state = await AsyncValue.guard(
      () => ref.read(postRepositoryProvider).getPosts(),
    );
  }

  /// Yeni bir gönderi ekler.
  Future<void> addPost({
    required String title,
    required String content,
    required String category,
  }) async {
    final postRepository = ref.read(postRepositoryProvider);
    try {
      // Sadece API'ye postu oluşturma isteği gönder.
      // State'i burada manuel olarak güncelleme.
      // `invalidate` işlemi listenin yeniden yüklenmesini sağlayacak.
      await postRepository.createPost(
        title: title,
        content: content,
        category: category,
      );
    } catch (e) {
      // Hata durumunda state'i güncellemek yerine hatayı yukarı fırlat.
      // UI katmanı bu hatayı yakalayıp kullanıcıya gösterebilir.
      rethrow;
    }
  }

  /// Bir gönderiyi günceller.
  Future<void> updatePost(
    String id, {
    required String title,
    required String content,
    required String category,
  }) async {
    final postRepository = ref.read(postRepositoryProvider);
    try {
      await postRepository.updatePost(
        id,
        title: title,
        content: content,
        category: category,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Bir gönderiyi siler.
  Future<void> removePost(String id) async {
    final postRepository = ref.read(postRepositoryProvider);
    try {
      await postRepository.deletePost(id);
    } catch (e) {
      rethrow;
    }
  }
}
