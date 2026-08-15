const jwt = require('jsonwebtoken');
const User = require('../models/User');

const protect = async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      // Token'ı header'dan al
      token = req.headers.authorization.split(' ')[1];

      // Token'ı doğrula
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Token'daki kullanıcıyı bul ve password hariç bilgileri req.user'a ekle
      req.user = await User.findById(decoded.id).select('-password');

      next();
    } catch (error) {
      console.error(error);
      return res.status(401).json({ message: 'Yetkilendirme başarısız, token geçersiz' });
    }
  }

  if (!token) {
    return res.status(401).json({ message: 'Yetkilendirme başarısız, token bulunamadı' });
  }
};

module.exports = { protect };
