import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.email == 'admin@gmail.com';

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserModel(user.uid);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserModel(String userId) async {
    _userModel = await _authService.getUserModel(userId);
    notifyListeners();
  }

  Future<String?> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.register(email, password, name);
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<String?> updateProfile(String name, String? phoneNumber) async {
    if (_user == null) return 'No user logged in';
    
    try {
      await _authService.updateUserProfile(_user!.uid, name, phoneNumber);
      await _loadUserModel(_user!.uid);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
