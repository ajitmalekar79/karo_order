import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _userTableName = 'users';

  // Sign up with mobile number as username
  Future<UserModel?> signUp({
    required String name,
    required String mobile,
    required String password,
    required String userTypeId,
    String? email,
  }) async {
    try {
      // 1️⃣ Create user in Supabase Auth
      final authResponse = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final authUser = authResponse.user;
      if (authUser == null) {
        throw Exception('User creation failed in Supabase Auth.');
      }

      // 2️⃣ Create matching record in your "users" table
      final userProfile = {
        'user_id': authUser.id,
        'user_type_id': userTypeId,
        'name': name,
        'email': email,
        'password_hash': password, // ideally hashed
        'mobile': mobile,
        'is_active': true,
        'is_deleted': false,
        'has_requested_vendor_approval': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Insert user into "users" and return the created record
      await _client
          .from(_userTableName)
          .insert(userProfile)
          .select('*')
          .maybeSingle();

      // 3️⃣ If insert didn’t return data, fetch manually by user_id

      final fetchResponse = await _client
          .from(_userTableName)
          .select('*')
          .eq('user_id', authUser.id)
          .maybeSingle();

      if (fetchResponse == null) {
        throw Exception('User record not found after insertion.');
      }
      return UserModel.fromJson(fetchResponse);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } on AuthException catch (e) {
      throw Exception('Auth error: ${e.message}');
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  // Sign in with mobile number
  Future<UserModel?> signIn({
    required String mobileNo,
    required String password,
  }) async {
    try {
      // Sign in using mobile number as email
      final authResponse = await _client.auth.signInWithPassword(
        email: mobileNo, //'$mobileNo@karoorder.com',
        password: password,
      );

      if (authResponse.user != null) {
        // Get user profile from custom table
        final response = await _client
            .from(_userTableName)
            .select()
            .eq('user_id', authResponse.user!.id)
            .single();

        final user = UserModel.fromJson(response);
        await _saveUserSession(user);
        return user;
      }
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
    return null;
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final session = _client.auth.currentSession;
      if (session?.user != null) {
        final response = await _client
            .from(_userTableName)
            .select()
            .eq('id', session!.user.id)
            .single();

        return UserModel.fromJson(response);
      }
    } catch (e) {
      // If error getting from database, try local storage
      return await _getUserFromLocal();
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      await _clearUserSession();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final session = _client.auth.currentSession;
    return session?.user != null;
  }

  // Save user session locally
  Future<void> _saveUserSession(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', user.toJson().toString());
    } catch (e) {
      // Handle storage error gracefully
    }
  }

  // Get user from local storage
  Future<UserModel?> _getUserFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        // Note: This is a simplified approach. In production, you'd want proper JSON parsing
        return null; // Return null for now, implement proper parsing if needed
      }
    } catch (e) {
      // Handle storage error gracefully
    }
    return null;
  }

  // Clear user session
  Future<void> _clearUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
    } catch (e) {
      // Handle storage error gracefully
    }
  }

  // Update user profile
  Future<UserModel?> updateUserProfile({
    required String userId,
    String? username,
    String? email,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (username != null) updates['username'] = username;
      if (email != null) updates['email'] = email;

      final response = await _client
          .from(_userTableName)
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Update profile failed: ${e.toString()}');
    }
  }

  // Check if mobile number already exists
  Future<bool> isMobileNumberExists(String mobileNo) async {
    try {
      final response = await _client
          .from(_userTableName)
          .select('id')
          .eq('mobile_no', mobileNo);

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Check if username already exists
  Future<bool> isUsernameExists(String username) async {
    try {
      final response = await _client
          .from(_userTableName)
          .select('id')
          .eq('username', username);

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
