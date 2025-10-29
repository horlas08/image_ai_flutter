class Env {
  static const String baseUrl = 'https://roomdesignaidec.com';
  static const String refreshEndpoint = '/auth/refresh/'; // adjust to your backend if different

  // AdMob (replace with your real IDs)
  static const String admobAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713'; // TEST
  static const String admobBannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111'; // TEST
  static const String admobInterstitialIdAndroid = 'ca-app-pub-3940256099942544/1033173712'; // TEST
  static const String admobRewardedIdAndroid = 'ca-app-pub-3940256099942544/5224354917'; // TEST

  static const String admobAppIdIos = 'ca-app-pub-3940256099942544~1458002511'; // TEST
  static const String admobBannerIdIos = 'ca-app-pub-3940256099942544/2934735716'; // TEST
  static const String admobInterstitialIdIos = 'ca-app-pub-3940256099942544/4411468910'; // TEST
  static const String admobRewardedIdIos = 'ca-app-pub-3940256099942544/1712485313'; // TEST

  // Subscription product identifiers (must match Play/App Store)
  static const String productYearly = 'pro_yearly_36';
  static const String productWeekly = 'pro_weekly_8';
}
