// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../models/login_state.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../widgets/draggable_login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginViewModel viewModel = Get.put(LoginViewModel());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              width: 350,
              child: Image.asset("assets/images/logo.png", fit: BoxFit.cover),
            ),
            Text(
              "Open a Book, Unlock a World.",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            Obx(() {
              final state = viewModel.state;
              return DraggableLoginButton(
                onLoginComplete: viewModel.signInWithGoogle,
                isLoading: state.status == LoginStatus.loading,
              );
            }),
            const SizedBox(height: 34),
            Text(
              "Powered by Rayonix Solutions",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => _showTermsDialog(context),
              child: Text(
                "Terms and Conditions",
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _showTermsDialog(BuildContext context) async {
    try {
      final String terms = await rootBundle.loadString(
        'assets/txt/TermsAndCondition.txt',
      );
      if (context.mounted) {
        showDialog(
          context: context,
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Text(
                            terms,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              height: 1.5,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        );
      }
    } catch (e) {
      debugPrint('Error loading terms: $e');
    }
  }
}
