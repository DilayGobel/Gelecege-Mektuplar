const dns = require('dns');
dns.setServers(['8.8.8.8', '8.8.4.4']);
const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const postRoutes = require('./routes/postRoutes');

// .env dosyasındaki değişkenleri yükle
dotenv.config();

// Veritabanı bağlantısı
connectDB();

const app = express();

// Middleware'ler
app.use(cors()); // CORS'u etkinleştir
app.use(express.json()); // Body parser (JSON verilerini ayrıştırmak için)

// API Rotaları
app.use('/api/auth', authRoutes);
app.use('/api/posts', postRoutes);

// Ana sayfa rotası (isteğe bağlı)
app.get('/', (req, res) => {
  res.send('API is running...');
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
