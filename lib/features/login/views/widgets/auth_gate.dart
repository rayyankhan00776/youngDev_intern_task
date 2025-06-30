// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../dashboard/views/pages/dashboard_page.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../models/login_state.dart';
import '../pages/login_page.dart';

class AuthGate extends StatelessWidget {
  final loginViewModel = Get.find<LoginViewModel>();

  AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = loginViewModel.user.value;
      final state = loginViewModel.state;

      // Only show loading during actual auth operations
      if (state.status == LoginStatus.loading && state.isAuthenticated) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // Show login page with loading indicator if authenticating
      if (state.status == LoginStatus.loading) {
        return Stack(
          children: [
            const LoginPage(),
            if (state.status == LoginStatus.loading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }

      // Once loaded, show either dashboard or login page based on auth state
      return user != null ?  DashboardPage() : const LoginPage();
    });
  }
}
