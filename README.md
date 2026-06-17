# ATK Mobile

Sistem Pengingat Stok Gudang ATK — Flutter client yang mengonsumsi REST API dari backend Laravel (project root `ATK/laravel`).

## Fitur
- Authentication (Laravel API token)
- Dashboard monitoring stok
- Scan Barcode/QR
- Input Stok (Masuk / Keluar)
- Riwayat stok per barang
- Firebase: FCM, Crashlytics, Analytics

## Menjalankan aplikasi (dev)

1. Pastikan Flutter terinstal dan `flutter doctor` bersih.
2. Buka folder proyek:

```bash
cd ATK/atk_mobile
flutter pub get
flutter run
```

Untuk menguji di emulator Android gunakan `flutter run` atau jalankan dari IDE.

## Konfigurasi Firebase (native)

Proyek sudah menyertakan konfigurasi Firebase Web di `lib/src/config/firebase_options.dart` (yang Anda berikan). Untuk Android/iOS tambahkan file native:

- Android: tempatkan `google-services.json` di `android/app/`.
- iOS: tempatkan `GoogleService-Info.plist` di `ios/Runner/` dan tambahkan file ke Xcode project.

Setelah menambahkan file native, sinkronkan gradle/pods:

```bash
cd android && ./gradlew clean
cd ../ios && pod install
```

## Permissions
- Camera permission: tambahkan ke `AndroidManifest.xml` dan `Info.plist` untuk scanner.

Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

iOS (`ios/Runner/Info.plist`): tambahkan `NSCameraUsageDescription` dengan pesan yang sesuai.

## Backend URL
Edit `lib/src/config/app_config.dart` `apiBaseUrl` untuk menunjuk ke server Laravel Anda (mis. `http://10.0.2.2:8000` untuk emulator Android).

## FCM Server
Server Laravel perlu mengirim pesan FCM ke topik `stok-gudang-atk` atau ke token yang terdaftar. Aplikasi ini otomatis subscribe ke topik tersebut.

## Testing & Crashlytics
- Crashlytics akan menangkap crash di runtime setelah Anda menambahkan konfigurasi native.

## Catatan UI
- Aplikasi menggunakan Material icons (tidak menggunakan emoticon/emoji untuk icon). Semua ikon berbasis `Icons.*`.

Jika Anda mau, saya bisa: menambahkan tema warna perusahaan, memperluas terjemahan, atau menyiapkan CI untuk build APK.
# atk_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
