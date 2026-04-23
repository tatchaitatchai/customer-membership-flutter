import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/gold_button.dart';
import '../../data/auth_api.dart';
import 'otp_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onRequestOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final phone = _phoneController.text.trim();
    final res = await ref.read(authApiProvider).requestOtp(phone: phone, purpose: 'LOGIN');

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!res.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error ?? 'ไม่สามารถส่ง OTP ได้')));
      return;
    }

    final data = res.data!;
    if (data.otpDebug != null) {
      // DEV: show OTP in SnackBar for quick testing when SMS_MOCK=true
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: PointsMeTheme.primaryGold,
          content: Text(
            'DEV OTP: ${data.otpDebug}  (ref: ${data.refNo})',
            style: const TextStyle(color: PointsMeTheme.darkBg, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpScreen(phoneNumber: phone, isRegistration: false, refNo: data.refNo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: PointsMeTheme.darkGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo area
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: PointsMeTheme.goldGradient,
                        boxShadow: [
                          BoxShadow(color: PointsMeTheme.primaryGold.withOpacity(0.3), blurRadius: 24, spreadRadius: 4),
                        ],
                      ),
                      child: const Icon(Icons.diamond_outlined, size: 48, color: PointsMeTheme.darkBg),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'POINTS ME',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: PointsMeTheme.primaryGold,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'สะสมแต้ม รับสิทธิพิเศษ',
                      style: TextStyle(fontSize: 14, color: PointsMeTheme.textSecondary, letterSpacing: 1),
                    ),

                    const SizedBox(height: 48),

                    // Phone input
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                      style: const TextStyle(fontSize: 18, letterSpacing: 2, color: PointsMeTheme.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'เบอร์โทรศัพท์',
                        hintText: '0812345678',
                        prefixIcon: Icon(Icons.phone_outlined, color: PointsMeTheme.primaryGold),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเบอร์โทรศัพท์';
                        }
                        if (value.length != 10) {
                          return 'เบอร์โทรศัพท์ต้องมี 10 หลัก';
                        }
                        return null;
                      },
                      enabled: !_isLoading,
                    ),

                    const SizedBox(height: 32),

                    GoldButton(text: 'เข้าสู่ระบบ', onPressed: _onRequestOtp, isLoading: _isLoading),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ยังไม่มีบัญชี? ', style: TextStyle(color: PointsMeTheme.textSecondary)),
                        GestureDetector(
                          onTap: () {
                            context.go('/register');
                          },
                          child: const Text(
                            'สมัครสมาชิก',
                            style: TextStyle(color: PointsMeTheme.primaryGold, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Privacy policy link
                    GestureDetector(
                      onTap: () {
                        context.push('/privacy-policy');
                      },
                      child: Text(
                        'นโยบายความเป็นส่วนตัว',
                        style: TextStyle(
                          color: PointsMeTheme.textMuted,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationColor: PointsMeTheme.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
