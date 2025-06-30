// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DraggableLoginButton extends StatefulWidget {
  final Future<void> Function() onLoginComplete;
  final bool isLoading;

  const DraggableLoginButton({
    super.key,
    required this.onLoginComplete,
    this.isLoading = false,
  });

  @override
  State<DraggableLoginButton> createState() => _DraggableLoginButtonState();
}

class _DraggableLoginButtonState extends State<DraggableLoginButton> {
  double _dragValue = 0.0;
  final double _dragThreshold = 0.6;

  Widget _buildDraggableButton(double screenWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Stack(
        children: [
          // Progress indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: screenWidth * _dragValue,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade200, Colors.grey.shade400],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          // Loading indicator
          if (widget.isLoading)
            Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.grey.shade400,
                  ),
                ),
              ),
            )
          else
            // Slide text
            Center(
              child: Text(
                "Slide to login with Google",
                style: GoogleFonts.urbanist(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          // Draggable button
          if (!widget.isLoading)
            Positioned(
              left: _dragValue * (screenWidth - 140),
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _dragValue += details.delta.dx / (screenWidth - 140);
                    _dragValue = _dragValue.clamp(0.0, 1.0);
                  });
                },
                onHorizontalDragEnd: (details) async {
                  if (_dragValue < _dragThreshold) {
                    setState(() => _dragValue = 0.0);
                  } else {
                    setState(() => _dragValue = 1.0);
                    await widget.onLoginComplete();
                  }
                },
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      "assets/images/google.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return _buildDraggableButton(screenWidth);
  }
}
