class AppConfig {
  static const googleServerClientId =
      String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID', defaultValue: '<<MISSING>>');

  static void validate() {
    assert(googleServerClientId.isNotEmpty,
      'Falta GOOGLE_SERVER_CLIENT_ID. Pásalo con --dart-define.');
  }
}
