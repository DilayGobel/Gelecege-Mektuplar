import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gelecege_mektuplar/data/models/post_model.dart';
import 'package:gelecege_mektuplar/providers/post_provider.dart';

class EditPostScreen extends ConsumerStatefulWidget {
  final PostModel post;
  const EditPostScreen({super.key, required this.post});

  @override
  ConsumerState<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  String? _selectedCategory;
  bool _isLoading = false;

  // HomeScreen'deki kategorilerle aynı listeyi kullanalım
  final List<String> _categories = [
    'Teknoloji',
    'Seyahat',
    'Yemek',
    'Yaşam',
    'Sanat',
  ];

  @override
  void initState() {
    super.initState();
    // Controller'ları ve kategoriyi mevcut yazı verileriyle başlat
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    // Postun kategorisi, tanımlı kategoriler listesinde yoksa,
    // DropdownButtonFormField'ın çökmesini önlemek için null olarak ayarla.
    // Kullanıcı bu durumda yeni bir kategori seçmek zorunda kalacak.
    _selectedCategory = _categories.contains(widget.post.category)
        ? widget.post.category
        : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _updatePost() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(postsProvider.notifier)
            .updatePost(
              widget.post.id,
              title: _titleController.text,
              content: _contentController.text,
              category: _selectedCategory!,
            );
        if (mounted) {
          // Hem ana listeyi hem de detay sayfasını yenile
          ref.invalidate(postsProvider);
          ref.invalidate(postDetailProvider(widget.post.id));
          Navigator.of(context).pop(); // Düzenleme ekranını kapat
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Yazı güncellenemedi: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yazıyı Düzenle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Lütfen başlık girin'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                hint: const Text('Kategori Seç'),
                isExpanded: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Lütfen bir kategori seçin' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'İçerik',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                validator: (value) => value == null || value.isEmpty
                    ? 'Lütfen içerik girin'
                    : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _updatePost,
                      child: const Text('GÜNCELLE'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
