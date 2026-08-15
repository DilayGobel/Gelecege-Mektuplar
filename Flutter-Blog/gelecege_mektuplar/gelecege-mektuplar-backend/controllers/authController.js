const jwt = require('jsonwebtoken');
const User = require('../models/User');

// JWT Token oluştur
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: '30d', // Token 30 gün geçerli olacak
  });
};

// @desc    Yeni kullanıcı kaydet
// @route   POST /api/auth/register
// @access  Public
const registerUser = async (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({ message: 'Lütfen tüm alanları doldurun' });
    }

    // Kullanıcının zaten var olup olmadığını kontrol et
    const userExists = await User.findOne({ email });

    if (userExists) {
      return res.status(400).json({ message: 'Bu e-posta adresi zaten kullanımda' });
    }

    // Yeni kullanıcı oluştur
    const user = await User.create({
      username,
      email,
      password, // Şifre User modelinin pre-save hook'unda hash'lenecek
    });

    if (user) {
      res.status(201).json({
        user: {
          _id: user._id,
          username: user.username,
          email: user.email,
        },
        token: generateToken(user._id),
      });
    } else {
      res.status(400).json({ message: 'Geçersiz kullanıcı verisi' });
    }
  } catch (error) {
    console.error('Kayıt sırasında hata:', error);
    res.status(500).json({ message: 'Sunucu hatası, kayıt işlemi başarısız oldu.' });
  }
};

// @desc    Kullanıcı girişi yap
// @route   POST /api/auth/login
// @access  Public
const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Kullanıcının e-postasını bul
    const user = await User.findOne({ email });

    // Kullanıcı varsa ve şifre eşleşiyorsa
    if (user && (await user.matchPassword(password))) {
      res.status(200).json({
        user: {
          _id: user._id,
          username: user.username,
          email: user.email,
        },
        token: generateToken(user._id),
      });
    } else {
      res.status(401).json({ message: 'Geçersiz e-posta veya şifre' });
    }
  } catch (error) {
    console.error('Giriş sırasında hata:', error);
    res.status(500).json({ message: 'Sunucu hatası, giriş işlemi başarısız oldu.' });
  }
};

module.exports = {
  registerUser,
  loginUser,
};
