import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/gold_button.dart';
import '../../../../common/widgets/premium_card.dart';

class RegisterNameScreen extends StatefulWidget {
  const RegisterNameScreen({super.key});

  @override
  State<RegisterNameScreen> createState() => _RegisterNameScreenState();
}

class _RegisterNameScreenState extends State<RegisterNameScreen> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showWelcome = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _showWelcome = true;
      });
    });
  }

  void _onContinue() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      return _buildWelcomeScreen();
    }
    return _buildNameInputScreen();
  }

  Widget _buildNameInputScreen() {
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
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PointsMeTheme.primaryGold.withOpacity(0.1),
                        border: Border.all(color: PointsMeTheme.primaryGold.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.badge_outlined, size: 32, color: PointsMeTheme.primaryGold),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'ตั้งชื่อของคุณ',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'ชื่อนี้จะแสดงในบัญชีสมาชิกของคุณ',
                      style: TextStyle(fontSize: 14, color: PointsMeTheme.textSecondary),
                    ),

                    const SizedBox(height: 40),

                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 18, color: PointsMeTheme.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'ชื่อ - นามสกุล',
                        hintText: 'กรอกชื่อของคุณ',
                        prefixIcon: Icon(Icons.person_outline, color: PointsMeTheme.primaryGold),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกชื่อ';
                        }
                        return null;
                      },
                      enabled: !_isLoading,
                    ),

                    const SizedBox(height: 32),

                    GoldButton(text: 'ยืนยัน', onPressed: _onSubmit, isLoading: _isLoading),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: PointsMeTheme.darkGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Celebration icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: PointsMeTheme.goldGradient,
                      boxShadow: [
                        BoxShadow(color: PointsMeTheme.primaryGold.withOpacity(0.4), blurRadius: 32, spreadRadius: 8),
                      ],
                    ),
                    child: const Icon(Icons.celebration_outlined, size: 48, color: PointsMeTheme.darkBg),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'ยินดีต้อนรับ, ${_nameController.text.trim()}!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'คุณได้รับแรงค์เริ่มต้น',
                    style: TextStyle(fontSize: 14, color: PointsMeTheme.textSecondary),
                  ),

                  const SizedBox(height: 24),

                  // Initial rank card
                  GoldGradientCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: PointsMeTheme.rankBronze.withOpacity(0.2),
                            border: Border.all(color: PointsMeTheme.rankBronze, width: 2),
                          ),
                          child: const Icon(Icons.workspace_premium, size: 32, color: PointsMeTheme.rankBronze),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'BRONZE',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: PointsMeTheme.rankBronze,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('สมาชิกระดับบรอนซ์', style: TextStyle(fontSize: 13, color: PointsMeTheme.textSecondary)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: PointsMeTheme.primaryGold, size: 18),
                            const SizedBox(width: 4),
                            const Text(
                              '0 แต้ม',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: PointsMeTheme.primaryGold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  GoldButton(text: 'เริ่มต้นใช้งาน', onPressed: _onContinue),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
