import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/gold_button.dart';
import '../../data/auth_api.dart';
import 'otp_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณายอมรับเงื่อนไขการใช้งาน')));
      return;
    }

    setState(() => _isLoading = true);
    final phone = _phoneController.text.trim();
    final res = await ref.read(authApiProvider).requestOtp(phone: phone, purpose: 'REGISTER');

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!res.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error ?? 'ไม่สามารถส่ง OTP ได้')));
      return;
    }

    final data = res.data!;
    if (data.otpDebug != null) {
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
        builder: (_) => OtpScreen(phoneNumber: phone, isRegistration: true, refNo: data.refNo),
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
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: PointsMeTheme.goldGradient,
                        boxShadow: [
                          BoxShadow(color: PointsMeTheme.primaryGold.withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
                        ],
                      ),
                      child: const Icon(Icons.person_add_outlined, size: 36, color: PointsMeTheme.darkBg),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'สมัครสมาชิก',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'เริ่มสะสมแต้มและรับสิทธิพิเศษ',
                      style: TextStyle(fontSize: 14, color: PointsMeTheme.textSecondary),
                    ),

                    const SizedBox(height: 40),

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

                    const SizedBox(height: 20),

                    // Terms checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _acceptedTerms,
                            onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                            activeColor: PointsMeTheme.primaryGold,
                            checkColor: PointsMeTheme.darkBg,
                            side: const BorderSide(color: PointsMeTheme.textMuted),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 13, color: PointsMeTheme.textSecondary),
                                children: [
                                  const TextSpan(text: 'ฉันยอมรับ '),
                                  TextSpan(
                                    text: 'เงื่อนไขการใช้งาน',
                                    style: TextStyle(
                                      color: PointsMeTheme.primaryGold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: PointsMeTheme.primaryGold,
                                    ),
                                  ),
                                  const TextSpan(text: ' และ '),
                                  TextSpan(
                                    text: 'นโยบายความเป็นส่วนตัว',
                                    style: TextStyle(
                                      color: PointsMeTheme.primaryGold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: PointsMeTheme.primaryGold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    GoldButton(text: 'สมัครสมาชิก', onPressed: _onRegister, isLoading: _isLoading),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('มีบัญชีอยู่แล้ว? ', style: TextStyle(color: PointsMeTheme.textSecondary)),
                        GestureDetector(
                          onTap: () {
                            context.go('/login');
                          },
                          child: const Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(color: PointsMeTheme.primaryGold, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
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
