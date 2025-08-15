class AppConfig {
  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '<<MISSING>>',
  );

  static const supabesServiceURL = String.fromEnvironment(
    'SUPABASE_SERVICE_URL',
    defaultValue: '<<MISSING>>',
  );

  static const supabesServiceAnonKey = String.fromEnvironment(
    'SUPABASE_SERVICE_ANON_KEY',
    defaultValue: '<<MISSING>>',
  );

  static void validate() {
    assert(
      googleServerClientId.isNotEmpty,
      'Falta GOOGLE_SERVER_CLIENT_ID. Pásalo con --dart-define.',
    );
  }
}
