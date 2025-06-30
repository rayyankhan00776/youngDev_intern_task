// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/login_state.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class LoginViewModel extends GetxController {
  final AuthService _authService;
  final _state = LoginState().obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  LoginViewModel({AuthService? authService})
    : _authService = authService ?? AuthService();

  LoginState get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  void _initializeAuth() {
    try {
      // Set initial user value without loading state
      user.value = _authService.currentUser;

      // Set initial state based on user
      _state.value = _state.value.copyWith(
        status: LoginStatus.initial,
        isAuthenticated: user.value != null,
        errorMessage: null,
      );

      // Listen to auth state changes
      ever(user, (UserModel? user) => _handleAuthStateChange());

      // Bind to auth stream
      user.bindStream(_authService.userStream);
    } catch (e) {
      _state.value = _state.value.copyWith(
        status: LoginStatus.error,
        errorMessage: 'Failed to initialize auth: $e',
        isAuthenticated: false,
      );
    }
  }

  void _handleAuthStateChange() {
    try {
      if (user.value != null) {
        _state.value = _state.value.copyWith(
          status: LoginStatus.success,
          isAuthenticated: true,
          errorMessage: null,
        );
        _showSuccess('Welcome ${user.value?.displayName ?? ""}!');
      } else {
        _state.value = _state.value.copyWith(
          status: LoginStatus.initial,
          isAuthenticated: false,
          errorMessage: null,
        );
      }
    } catch (e) {
      _state.value = _state.value.copyWith(
        status: LoginStatus.error,
        errorMessage: 'Error handling auth state: $e',
      );
    }
  }

  void _showError(String message) {
    Get.closeAllSnackbars(); // Close any existing snackbars
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
      colorText: Get.theme.colorScheme.error,
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      borderRadius: 8,
      icon: Icon(Icons.error_outline, color: Get.theme.colorScheme.error),
    );
  }

  void _showSuccess(String message) {
    Get.closeAllSnackbars(); // Close any existing snackbars
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade700,
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      borderRadius: 8,
      icon: Icon(Icons.check_circle_outline, color: Colors.green.shade700),
    );
  }

  Future<void> signInWithGoogle() async {
    if (_state.value.status == LoginStatus.loading) return;

    try {
      _state.value = _state.value.copyWith(
        status: LoginStatus.loading,
        errorMessage: null,
      );

      final userModel = await _authService.signInWithGoogle();

      if (userModel == null) {
        throw Exception('Failed to sign in with Google');
      }

      _state.value = _state.value.copyWith(
        status: LoginStatus.success,
        isAuthenticated: true,
      );
    } catch (e) {
      _state.value = _state.value.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString(),
        isAuthenticated: false,
      );
      _showError(e.toString());
    }
  }

  Future<void> signOut() async {
    if (_state.value.status == LoginStatus.loading) return;

    try {
      _state.value = _state.value.copyWith(status: LoginStatus.loading);
      await _authService.signOut();
      _state.value = _state.value.copyWith(
        status: LoginStatus.initial,
        isAuthenticated: false,
      );
      _showSuccess('Signed out successfully');
    } catch (e) {
      _state.value = _state.value.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString(),
      );
      _showError(e.toString());
    }
  }
}
