class AppConfig {
  // Ganti IP berikut dengan IP laptop Anda jika beda jaringan
  // Cek IP laptop: ip a | grep wlan0 (wifi) atau ip a | grep eth0 (ethernet)
  static const apiBaseUrl = 'http://192.168.100.217:8000';
  static const authTokenKey = 'auth_token';
  static const fcmTopic = 'stok-gudang-atk';
  static const useMockApi = false;
}
