const Post = require('../models/Post');
const User = require('../models/User');

// @desc    Tüm yazıları getir
// @route   GET /api/posts
// @access  Public
const getPosts = async (req, res) => {
  const pageSize = 10; // Sayfa başına gönderi sayısı
  const page = Number(req.query.pageNumber) || 1; // Mevcut sayfa numarası

  const keyword = req.query.search
    ? {
        $or: [
          { title: { $regex: req.query.search, $options: 'i' } },
          { content: { $regex: req.query.search, $options: 'i' } },
        ],
      }
    : {};

  const categoryFilter = req.query.category
    ? { category: { $regex: req.query.category, $options: 'i' } }
    : {};

  const count = await Post.countDocuments({ ...keyword, ...categoryFilter });
  const posts = await Post.find({ ...keyword, ...categoryFilter })
    .populate('author', 'username email')
    .limit(pageSize)
    .skip(pageSize * (page - 1))
    .sort({ createdAt: -1 }); // En yeni gönderiler önce gelir

  res.json({ posts, page, pages: Math.ceil(count / pageSize) });
};

// @desc    Tekil yazı detayını getir
// @route   GET /api/posts/:id
// @access  Public
const getPostById = async (req, res) => {
  const post = await Post.findById(req.params.id).populate(
    'author',
    'username email'
  );

  if (post) {
    res.json(post);
  } else {
    res.status(404).json({ message: 'Yazı bulunamadı' });
  }
};

// @desc    Yeni yazı oluştur
// @route   POST /api/posts
// @access  Private
const createPost = async (req, res) => {
  const { title, content, category } = req.body;

  if (!title || !content || !category) {
    res.status(400).json({ message: 'Lütfen tüm alanları doldurun' });
    return;
  }

  const post = new Post({
    title,
    content,
    category,
    author: req.user._id, // Auth middleware'dan gelen kullanıcı bilgisi
  });

  await post.save();
  res.status(201).send(); // Sadece başarı durumunu gönder, body gönderme
};

// @desc    Yazı güncelle
// @route   PUT /api/posts/:id
// @access  Private
const updatePost = async (req, res) => {
  const { title, content, category } = req.body;

  const post = await Post.findById(req.params.id);

  if (!post) {
    return res.status(404).json({ message: 'Yazı bulunamadı' });
  }

  // Yazıyı sadece sahibi güncelleyebilir
  if (post.author.toString() !== req.user._id.toString()) {
    return res.status(403).json({ message: 'Bu yazıyı düzenleme yetkiniz yok' });
  }

  post.title = title || post.title;
  post.content = content || post.content;
  post.category = category || post.category;

  await post.save();
  res.status(200).send(); // Sadece başarı durumunu gönder, body gönderme
};

// @desc    Yazı sil
// @route   DELETE /api/posts/:id
// @access  Private
const deletePost = async (req, res) => {
  const post = await Post.findById(req.params.id);

  if (!post) {
    return res.status(404).json({ message: 'Yazı bulunamadı' });
  }

  // Yazıyı sadece sahibi silebilir
  if (post.author.toString() !== req.user._id.toString()) {
    return res.status(403).json({ message: 'Bu yazıyı silme yetkiniz yok' });
  }

  await Post.deleteOne({ _id: req.params.id });
  res.status(200).json({ message: 'Yazı başarıyla silindi' });
};

module.exports = {
  getPosts,
  getPostById,
  createPost,
  deletePost,
  updatePost,
};
