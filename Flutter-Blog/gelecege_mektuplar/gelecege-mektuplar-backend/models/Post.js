const mongoose = require('mongoose');

const postSchema = mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'Lütfen bir başlık girin'],
      trim: true,
    },
    content: {
      type: String,
      required: [true, 'Lütfen içerik girin'],
    },
    category: {
      type: String,
      required: [true, 'Lütfen bir kategori girin'],
      trim: true,
    },
    author: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: 'User', // User modeline referans
    },
  },
  {
    timestamps: true,
  }
);

const Post = mongoose.model('Post', postSchema);

module.exports = Post;
