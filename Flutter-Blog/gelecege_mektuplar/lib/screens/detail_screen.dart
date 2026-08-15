import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';
import 'edit_post_screen.dart';

class DetailScreen extends ConsumerWidget {
  final String postId;
  const DetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postDetailAsyncValue = ref.watch(postDetailProvider(postId));
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yazı Detayı'),
        actions: [
          // Sadece post sahibi ise düzenle ve sil butonlarını göster
          postDetailAsyncValue.when(
            data: (post) {
              final currentUser = authState.whenOrNull(
                authenticated: (user) => user,
              );
              if (currentUser != null && currentUser.id == post.author.id) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditPostScreen(post: post),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // Silme işlemi ve onayı
                        final confirmed = await _showDeleteConfirmationDialog(
                          context,
                        );
                        if (confirmed) {
                          await ref
                              .read(postsProvider.notifier)
                              .removePost(post.id);
                          ref.invalidate(postsProvider); // Ana listeyi yenile
                          if (context.mounted) Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: postDetailAsyncValue.when(
        data: (post) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Yazar: ${post.author.username}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yayınlanma Tarihi: ${post.createdAt.toLocal().toString().split(' ')[0]}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Divider(color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: 16),
                Text(
                  post.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Yazıyı Sil'),
              content: const Text(
                'Bu yazıyı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('İptal'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Sil'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false; // Dialog kapatılırsa false dön
  }
}
