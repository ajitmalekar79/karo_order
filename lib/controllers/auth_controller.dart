import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<AuthState> _state = AuthState.initial.obs;
  final Rxn<UserModel> _user = Rxn<UserModel>();
  final RxnString _errorMessage = RxnString();

  AuthState get state => _state.value;
  UserModel? get user => _user.value;
  String? get errorMessage => _errorMessage.value;
  bool get isAuthenticated =>
      _state.value == AuthState.authenticated && _user.value != null;
  bool get isLoading => _state.value == AuthState.loading;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _setState(AuthState.loading);
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        final userData = await _authService.getCurrentUser();
        if (userData != null) {
          _user.value = userData;
          _setState(AuthState.authenticated);
        } else {
          _setState(AuthState.unauthenticated);
        }
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setError('Failed to initialize authentication: ${e.toString()}');
    }
  }

  Future<bool> signUp({
    required String username,
    required String mobileNo,
    required String password,
    String? email,
  }) async {
    _setState(AuthState.loading);
    try {
      final user = await _authService.signUp(
        username: username,
        mobileNo: mobileNo,
        password: password,
        email: email,
      );

      if (user != null) {
        _user.value = user;
        _setState(AuthState.authenticated);
        return true;
      } else {
        _setError('Sign up failed');
        return false;
      }
    } catch (e) {
      _setError('Sign up error: ${e.toString()}');
      return false;
    }
  }

  Future<bool> signIn({
    required String mobileNo,
    required String password,
  }) async {
    _setState(AuthState.loading);
    try {
      final user = await _authService.signIn(
        mobileNo: mobileNo,
        password: password,
      );

      if (user != null) {
        _user.value = user;
        _setState(AuthState.authenticated);
        return true;
      } else {
        _setError('Invalid credentials');
        return false;
      }
    } catch (e) {
      _setError('Sign in error: ${e.toString()}');
      return false;
    }
  }

  Future<void> signOut() async {
    _setState(AuthState.loading);
    try {
      await _authService.signOut();
      _user.value = null;
      _setState(AuthState.unauthenticated);
    } catch (e) {
      _setError('Sign out error: ${e.toString()}');
    }
  }

  void clearError() {
    _errorMessage.value = null;
  }

  void _setState(AuthState newState) {
    _state.value = newState;
    if (newState != AuthState.error) {
      _errorMessage.value = null;
    }
  }

  void _setError(String error) {
    _errorMessage.value = error;
    _state.value = AuthState.error;
  }
}
