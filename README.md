# Geleceğe Mektuplar - Cross-Platform Mobile Blog & News App

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![Render](https://img.shields.io/badge/Render-46E3B7?style=for-the-badge&logo=render&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)

## Projeye Genel Bakış (Overview)

Geleceğe Mektuplar, Flutter ve Node.js teknolojileri kullanılarak geliştirilmiş, modern ve cross-platform bir blog/haber uygulamasıdır. Bu proje, güvenli kullanıcı yönetimi, dinamik içerik oluşturma (CRUD) ve modern bir kullanıcı arayüzü (UI/UX) gibi temel özellikleri bir araya getirerek, full-stack uygulama geliştirme yeteneklerimi sergilemek amacıyla oluşturulmuştur. Backend REST API'ı Render.com üzerinde canlı olarak yayınlanmaktadır.

## Temel Özellikler (Key Features)

### Mobile (Flutter)
- **Güvenli Kimlik Doğrulama:** Register, Login ve Auto-Login akışları. JWT'nin `flutter_secure_storage` ile Keystore/Keychain üzerinde şifreli olarak saklanması.
- **Otomatik Token Yönetimi:** `Dio Interceptor`'ı ile API isteklerinin `Authorization: Bearer <token>` başlığını otomatik olarak eklemesi.
- **Asenkron Durum Yönetimi:** `Riverpod` (StateNotifier/AsyncNotifier) kullanarak Loading, Error ve Data durumlarının yönetimi.
- **Dinamik İçerik Yönetimi:** Kullanıcıların gönderi oluşturmasına, kendi gönderilerini silmesine ve listeyi `Pull-to-Refresh` ile yenilemesine olanak tanır.
- **Anlık Arama ve Filtreleme:** Kategori bazlı filtreleme ve anlık arama yetenekleri.
- **Modern UI/UX:** Material 3 tasarım diline uygun, Shimmer/Skeleton yükleme animasyonları ve responsive kart yapıları ile modern bir arayüz.

### Backend (Node.js)
- **RESTful API:** Node.js ve Express.js ile oluşturulmuş, standart CRUD operasyonlarını destekleyen REST API.
- **Veritabanı Entegrasyonu:** Mongoose ODM ile MongoDB Atlas veritabanı entegrasyonu.
- **JWT Tabanlı Güvenlik:** `jsonwebtoken` ile kullanıcı kimlik doğrulama ve yetkilendirme. `bcryptjs` ile parola hash'leme.
- **CORS & Environment Management:** `cors` ve `dotenv` paketleri ile güvenli ve esnek konfigürasyon yönetimi.

## Mimari ve Dizin Yapısı (Project Structure)

```
Flutter-Blog/
├── gelecege_mektuplar/
│   ├── lib/
│   │   ├── core/               # Network, Theme, Constants
│   │   ├── data/               # Models (Freezed), Repositories
│   │   ├── providers/          # Riverpod State Management
│   │   └── screens/            # UI Katmanı
│   ├── pubspec.yaml
│   └── README.md
└── gelecege-mektuplar-backend/
    ├── controllers/            # İstek ve cevap mantığı
    ├── middleware/             # Auth doğrulama
    ├── models/                 # Veritabanı şemaları (Mongoose)
    ├── routes/                 # API endpoint tanımları
    └── server.js               # Ana sunucu dosyası
```

## Kullanılan Teknolojiler Tablosu (Tech Stack)

| Kategori | Teknoloji | Açıklama |
| :--- | :--- | :--- |
| **Frontend** | Flutter, Dart 3+ | Cross-platform mobil uygulama geliştirme. |
| **State Management** | Riverpod | Asenkron ve reaktif durum yönetimi. |
| **Networking** | Dio, Custom Interceptors| Güvenli ve modüler HTTP istekleri. |
| **UI/UX** | Material 3, CachedNetworkImage| Modern tasarım dili ve verimli resim yükleme. |
| **Secure Storage** | flutter_secure_storage | Keystore/Keychain üzerinde şifreli veri saklama. |
| **Backend** | Node.js, Express.js | Hızlı ve ölçeklenebilir REST API. |
| **Database** | MongoDB Atlas, Mongoose | NoSQL bulut veritabanı ve ODM. |
| **Authentication** | JWT, bcryptjs | Token tabanlı güvenlik ve parola hash'leme. |
| **Deployment** | Render.com, GitHub | Bulut tabanlı web servisi ve versiyon kontrol. |

## Kurulum ve Çalıştırma Adımları (Getting Started)

### Önkoşullar (Prerequisites)
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x veya üstü)
- [Node.js](https://nodejs.org/en/download/) (18.x veya üstü)
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) hesabı

### Backend Kurulumu
1.  **Backend dizinine gidin:**
    ```bash
    cd gelecege-mektuplar-backend
    ```
2.  **Gerekli paketleri kurun:**
    ```bash
    npm install
    ```
3.  **`.env` dosyasını oluşturun ve yapılandırın:**
    ```env
    MONGO_URI=mongodb+srv://<user>:<password>@<cluster-url>/<db-name>?retryWrites=true&w=majority
    JWT_SECRET=your_super_secret_jwt_key
    PORT=5000
    ```
4.  **Sunucuyu başlatın:**
    ```bash
    npm start
    ```

### Flutter Kurulumu
1.  **Flutter projesi dizinine gidin:**
    ```bash
    cd gelecege_mektuplar
    ```
2.  **Gerekli paketleri kurun:**
    ```bash
    flutter pub get
    ```
3.  **Uygulamayı çalıştırın:**
    ```bash
    flutter run
    ```
    *Not: `lib/core/constants/api_constants.dart` dosyasındaki `baseUrl`'i kendi backend adresinizle güncellemeyi unutmayın.*

## REST API Dokümantasyonu (Endpoints Table)

| Metot | Endpoint | Açıklama | Auth Gerekli mi? |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/auth/register` | Yeni kullanıcı kaydı oluşturur. | Hayır |
| `POST` | `/api/auth/login` | Kullanıcı girişi yapar ve JWT döndürür. | Hayır |
| `GET` | `/api/posts` | Tüm gönderileri listeler. | Hayır |
| `GET` | `/api/posts/:id` | Tek bir gönderiyi ID ile getirir. | Hayır |
| `POST` | `/api/posts` | Yeni bir gönderi oluşturur. | Evet |
| `DELETE`| `/api/posts/:id` | Bir gönderiyi ID ile siler. | Evet |
| `PUT` | `/api/posts/:id` | Bir gönderiyi ID ile günceller. | Evet |
