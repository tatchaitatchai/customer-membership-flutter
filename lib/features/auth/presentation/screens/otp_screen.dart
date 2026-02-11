import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/gold_button.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isRegistration;

  const OtpScreen({super.key, required this.phoneNumber, this.isRegistration = false});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _resendCountdown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _resendCountdown = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto-verify when all fields are filled
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      _verifyOtp(otp);
    }
  }

  void _verifyOtp(String otp) {
    setState(() => _isLoading = true);

    // Simulate OTP verification
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (widget.isRegistration) {
        context.go('/register-name');
      } else {
        context.go('/home');
      }
    });
  }

  String get _maskedPhone {
    final phone = widget.phoneNumber;
    if (phone.length >= 10) {
      return '${phone.substring(0, 3)}-XXX-${phone.substring(7)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: PointsMeTheme.darkGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios, color: PointsMeTheme.textPrimary),
                  ),
                ),

                const SizedBox(height: 32),

                // Lock icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PointsMeTheme.primaryGold.withOpacity(0.1),
                    border: Border.all(color: PointsMeTheme.primaryGold.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.lock_outline, size: 32, color: PointsMeTheme.primaryGold),
                ),

                const SizedBox(height: 24),

                const Text(
                  'ยืนยัน OTP',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
                ),

                const SizedBox(height: 8),

                Text(
                  'รหัส OTP ถูกส่งไปที่ $_maskedPhone',
                  style: const TextStyle(fontSize: 14, color: PointsMeTheme.textSecondary),
                ),

                const SizedBox(height: 40),

                // OTP input boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      height: 56,
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: PointsMeTheme.primaryGold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: PointsMeTheme.darkCardLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: PointsMeTheme.dividerColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: PointsMeTheme.primaryGold, width: 2),
                          ),
                        ),
                        onChanged: (value) => _onOtpChanged(index, value),
                        enabled: !_isLoading,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                if (_isLoading)
                  const CircularProgressIndicator(color: PointsMeTheme.primaryGold)
                else
                  GoldButton(
                    text: 'ยืนยัน',
                    onPressed: () {
                      final otp = _controllers.map((c) => c.text).join();
                      if (otp.length == 6) {
                        _verifyOtp(otp);
                      }
                    },
                  ),

                const SizedBox(height: 24),

                // Resend OTP
                _resendCountdown > 0
                    ? Text(
                        'ส่งรหัสอีกครั้งใน $_resendCountdown วินาที',
                        style: const TextStyle(color: PointsMeTheme.textMuted, fontSize: 14),
                      )
                    : GestureDetector(
                        onTap: () {
                          _startCountdown();
                          // Resend OTP logic
                        },
                        child: const Text(
                          'ส่งรหัส OTP อีกครั้ง',
                          style: TextStyle(color: PointsMeTheme.primaryGold, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
