# Testing Guide - ATK Mobile

## Prerequisites

- Flutter 3.41.9+ installed
- Chrome/web browser (untuk testing web)
- Atau Android device/emulator (untuk native testing)

## Run di Web (Chrome)

```bash
cd ATK/atk_mobile
flutter pub get
flutter run -d chrome
```

Aplikasi akan terbuka di Chrome. Anda akan melihat:
- Login page dengan field Email dan Password
- Material Design UI
- No emoji icons (semua menggunakan Material Icons)

## Test Workflow

### 1. Login
- Email: `user@example.com` (atau email valid apapun)
- Password: `password` (atau password apapun)
- **Catatan**: Untuk testing tanpa backend Laravel, lihat "Mock Backend" di bawah.

### 2. Dashboard
Setelah login berhasil:
- Akan menampilkan list barang dengan status (Habis/Menipis/Aman)
- Setiap item memiliki:
  - Avatar dengan jumlah stok dan warna indicator
  - Nama barang dan kategori
  - Tombol History (riwayat) dan Edit (input stok)
- FAB dengan icon scanner untuk membuka halaman scan

### 3. Scan Barcode/QR
- Klik FAB scanner di dashboard
- Page akan membuka dengan MobileScanner (web: tidak support kamera)
- **Catatan**: Untuk emulator/device Android, gunakan `flutter run` di device tersebut

### 4. Input Stok
- Klik tombol Edit di salah satu item barang
- Form akan dibuka dengan radio button untuk:
  - Masuk (penambahan stok)
  - Keluar (pengurangan stok)
- Input jumlah
- Click "Kirim" untuk submit
- Akan kembali ke dashboard setelah sukses

### 5. Riwayat Stok
- Klik tombol History di salah satu item barang
- Akan menampilkan list history dengan timestamp

## Mock Backend (untuk testing UI tanpa Laravel)

Jika Anda ingin test UI tanpa backend Laravel aktif, saya sudah menyiapkan mock provider yang bisa diaktifkan di `lib/src/core/network/api_client.dart`. 

Untuk development/testing, ubah `apiBaseUrl` di `lib/src/config/app_config.dart` menjadi URL lokal atau gunakan interceptor Dio:

```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      // Mock login response untuk test
      if (options.path == '/api/login') {
        return handler.resolve(Response(
          data: {'token': 'mock-token-12345'},
          statusCode: 200,
          requestOptions: options,
        ));
      }
      // Mock barang list untuk test
      if (options.path == '/api/barang') {
        return handler.resolve(Response(
          data: [
            {'id': 1, 'nama_barang': 'Kertas A4', 'kategori': 'Kertas', 'stok': 50, 'batas_minimum': 10, 'status': 'aman'},
            {'id': 2, 'nama_barang': 'Tinta Biru', 'kategori': 'Tinta', 'stok': 3, 'batas_minimum': 5, 'status': 'menipis'},
            {'id': 3, 'nama_barang': 'Stapler', 'kategori': 'Alat', 'stok': 0, 'batas_minimum': 2, 'status': 'habis'},
          ],
          statusCode: 200,
          requestOptions: options,
        ));
      }
      return handler.next(options);
    },
  ),
);
```

## Firebase Messaging (FCM) - Web Warning

Saat menjalankan di web Chrome, Anda mungkin melihat warning:
```
firebase_messaging/failed-service-worker-registration
Script MIME type text/html
```

Ini adalah limitation web development tanpa static server yang proper. Untuk production web:
- Setup backend web server dengan MIME type yang benar untuk `.js` files
- Atau update Firebase config untuk menghandle service worker registration

Untuk native Android/iOS, FCM bekerja normal dengan setup google-services.json / GoogleService-Info.plist.

## Localization (EN/ID)

App ini support English dan Indonesian. Default locale akan sesuai dengan device system locale. Untuk test:
- Device EN → UI akan dalam English
- Device ID → UI akan dalam Indonesian

Semua strings sudah ter-localize di `lib/src/l10n/app_localizations.dart`.

## Hot Reload / Debug

Saat app sedang running, Anda bisa:
- Press `r` → Hot reload (code changes tanpa state loss)
- Press `R` → Hot restart (full app restart)
- Press `d` → Detach (tutup Flutter CLI, app tetap jalan)
- Press `q` → Quit (stop app)

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Web (Chrome) | ✓ | UI testing, no camera access, FCM warning normal |
| Android Emulator | ✓ | Full support dengan google-services.json |
| Android Device | ✓ | Full support dengan google-services.json |
| iOS Simulator | ✓ | Full support dengan GoogleService-Info.plist |
| iOS Device | ✓ | Full support dengan GoogleService-Info.plist |

## Troubleshooting

**Q: Login gagal**
A: Pastikan backend Laravel berjalan di URL yang benar (default: `http://10.0.2.2:8000`). Atau gunakan mock interceptor (lihat Mock Backend di atas).

**Q: Scanner tidak berjalan di web**
A: Scanner memerlukan akses kamera. Web Chrome memiliki limitation untuk production. Gunakan Android/iOS device untuk test scanner.

**Q: FCM tidak menerima notifikasi**
A: Pastikan:
- Backend Laravel mengirim pesan ke topik `stok-gudang-atk`
- Aplikasi sudah ter-install dengan proper Firebase config (google-services.json untuk Android)
- Device terhubung internet

**Q: App crash saat startup**
A: Check error di console/logcat. Kemungkinan:
- Firebase initialization gagal
- Backend URL tidak accessible
- Missing native config files

Lihat README.md untuk setup Firebase native files.
