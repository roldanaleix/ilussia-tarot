import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Singleton pattern
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Cliente de Supabase
  SupabaseClient get client => Supabase.instance.client;

  // Nombre de la tabla
  static const String _usersTable = 'users';

  // ========================
  // MÉTODOS DE USUARIOS
  // ========================

  /// Obtener usuario por UID
  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      final response = await client
          .from(_usersTable)
          .select()
          .eq('uid', uid)
          .single();

      return response;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Crear un nuevo usuario
  Future<bool> createUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
  }) async {
    try {
      final userData = {
        'uid': uid,
        'email': email,
        'display_name': displayName,
        'photo_url': photoUrl,
        'phone_number': phoneNumber,
        'is_active': true,
        'profile_complete': false,
      };

      await client.from(_usersTable).insert(userData);
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  /// Actualizar usuario existente
  Future<bool> updateUser({
    required String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    bool? isActive,
    bool? profileComplete,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (email != null) updateData['email'] = email;
      if (displayName != null) updateData['display_name'] = displayName;
      if (photoUrl != null) updateData['photo_url'] = photoUrl;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (isActive != null) updateData['is_active'] = isActive;
      if (profileComplete != null)
        updateData['profile_complete'] = profileComplete;

      // Siempre actualizar el timestamp
      updateData['updated_at'] = DateTime.now().toIso8601String();

      await client.from(_usersTable).update(updateData).eq('uid', uid);

      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  /// Eliminar usuario (soft delete)
  Future<bool> deactivateUser(String uid) async {
    try {
      await client
          .from(_usersTable)
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('uid', uid);

      return true;
    } catch (e) {
      print('Error deactivating user: $e');
      return false;
    }
  }

  /// Verificar si usuario existe
  Future<bool> userExists(String uid) async {
    try {
      final response = await client
          .from(_usersTable)
          .select('uid')
          .eq('uid', uid)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }

  /// Obtener usuarios activos (para admin)
  Future<List<Map<String, dynamic>>> getActiveUsers() async {
    try {
      final response = await client
          .from(_usersTable)
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting active users: $e');
      return [];
    }
  }

  /// Buscar usuarios por email
  Future<List<Map<String, dynamic>>> searchUsersByEmail(String email) async {
    try {
      final response = await client
          .from(_usersTable)
          .select()
          .ilike('email', '%$email%')
          .eq('is_active', true)
          .limit(10);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  // ========================
  // MÉTODOS DE UTILIDAD
  // ========================

  /// Stream para escuchar cambios en tiempo real
  Stream<List<Map<String, dynamic>>> watchUser(String uid) {
    return client
        .from(_usersTable)
        .stream(primaryKey: ['uid'])
        .eq('uid', uid)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  /// Stream para escuchar todos los usuarios activos
  Stream<List<Map<String, dynamic>>> watchActiveUsers() {
    return client
        .from(_usersTable)
        .stream(primaryKey: ['uid'])
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }
}
