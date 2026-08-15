import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gelecege_mektuplar/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import '../data/models/post_model.dart';
import '../providers/post_provider.dart';
import 'create_post_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The initial fetch is handled by the PostController's build method.
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category == _selectedCategory ? null : category;
    });
    ref.read(postsProvider.notifier).fetchPosts(
          search: _searchQuery.isEmpty ? null : _searchQuery,
          category: _selectedCategory,
        );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    ref.read(postsProvider.notifier).fetchPosts(
          search: _searchQuery.isEmpty ? null : _searchQuery,
          category: _selectedCategory,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final postListAsyncValue = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geleceğe Mektuplar'),
        actions: [
          if (authState.whenOrNull(authenticated: (_) => true) ?? false)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Yazı ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          _buildCategoryChips(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(postsProvider.notifier).refreshPosts(),
              child: postListAsyncValue.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return const Center(child: Text('Henüz yazı bulunamadı.'));
                  }
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return _PostCard(post: post);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Hata: $err')),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          authState.whenOrNull(authenticated: (_) => true) ?? false
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreatePostScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }

  Widget _buildCategoryChips() {
    // Dummy categories for now, in a real app these might come from an API
    final List<String> categories = [
      'Teknoloji',
      'Seyahat',
      'Yemek',
      'Yaşam',
      'Sanat',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                _onCategorySelected(category);
              },
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _PostCard extends StatelessWidget {
  final PostModel post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailScreen(postId: post.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                post.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  Chip(
                    label: Text(post.category),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                  if (post.author.username.isNotEmpty)
                    Chip(
                      label: Text('Yazar: ${post.author.username}'),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    ),
                  Text(
                    'Tarih: ${DateFormat('yyyy-MM-dd').format(post.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
