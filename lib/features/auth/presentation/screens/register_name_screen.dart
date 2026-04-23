import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/gold_button.dart';
import '../../../../common/widgets/premium_card.dart';
import '../../data/auth_api.dart';

class RegisterNameScreen extends ConsumerStatefulWidget {
  final String registrationToken;
  final String phone;

  const RegisterNameScreen({super.key, this.registrationToken = '', this.phone = ''});

  @override
  ConsumerState<RegisterNameScreen> createState() => _RegisterNameScreenState();
}

class _RegisterNameScreenState extends ConsumerState<RegisterNameScreen> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showWelcome = false;

  // Step: 0 = name input, 1 = store picker
  int _step = 0;
  List<StoreDto> _stores = const [];
  int? _selectedStoreId;
  bool _storesLoading = false;
  String? _storesError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onNameNext() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.registrationToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ข้อมูลสมัครหมดอายุ กรุณาเริ่มใหม่')));
      return;
    }
    setState(() {
      _step = 1;
      _storesLoading = true;
      _storesError = null;
    });
    final res = await ref.read(authApiProvider).listStores();
    if (!mounted) return;
    setState(() {
      _storesLoading = false;
      if (res.isSuccess) {
        _stores = res.data ?? const [];
      } else {
        _storesError = res.error ?? 'โหลดรายชื่อร้านไม่สำเร็จ';
      }
    });
  }

  Future<void> _onSubmit() async {
    if (_selectedStoreId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเลือกร้าน')));
      return;
    }
    setState(() => _isLoading = true);
    final res = await ref
        .read(authApiProvider)
        .register(
          registrationToken: widget.registrationToken,
          fullName: _nameController.text.trim(),
          storeId: _selectedStoreId!,
        );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!res.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error ?? 'สมัครสมาชิกไม่สำเร็จ')));
      return;
    }

    final data = res.data!;
    if (data.sessionToken != null) {
      await ref.read(authApiProvider).saveSession(data.sessionToken!);
    }
    if (!mounted) return;

    if (data.status == 'NEEDS_MIGRATION_DECISION') {
      // Backend found legacy unlinked customers at this store with the same
      // phone last4 — defer to user decision.
      context.go(
        '/migration-decision',
        extra: {'store_id': data.storeId ?? _selectedStoreId, 'candidates': data.candidates},
      );
      return;
    }

    if (data.status == 'CREATED') {
      setState(() => _showWelcome = true);
    }
  }

  void _onContinue() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      return _buildWelcomeScreen();
    }
    if (_step == 1) {
      return _buildStorePickerScreen();
    }
    return _buildNameInputScreen();
  }

  Widget _buildStorePickerScreen() {
    return Scaffold(
      backgroundColor: PointsMeTheme.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: PointsMeTheme.textPrimary),
          onPressed: _isLoading ? null : () => setState(() => _step = 0),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: PointsMeTheme.darkGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'เลือกร้านที่สมัคร',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'คุณจะเป็นสมาชิกของร้านที่เลือก ข้อมูลแต้มและสิทธิพิเศษจะอยู่ภายในร้านนั้น',
                  style: TextStyle(fontSize: 13, color: PointsMeTheme.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _storesLoading
                      ? const Center(child: CircularProgressIndicator(color: PointsMeTheme.primaryGold))
                      : _storesError != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_storesError!, style: const TextStyle(color: PointsMeTheme.textSecondary)),
                              const SizedBox(height: 16),
                              TextButton(onPressed: _onNameNext, child: const Text('ลองใหม่')),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: _stores.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final s = _stores[i];
                            final selected = s.id == _selectedStoreId;
                            return PremiumCard(
                              padding: EdgeInsets.zero,
                              child: InkWell(
                                onTap: _isLoading ? null : () => setState(() => _selectedStoreId = s.id),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  child: Row(
                                    children: [
                                      Icon(
                                        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                        color: selected ? PointsMeTheme.primaryGold : PointsMeTheme.textSecondary,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          s.storeName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: PointsMeTheme.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                GoldButton(
                  text: 'สมัครสมาชิก',
                  onPressed: _selectedStoreId == null ? null : _onSubmit,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
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

                    GoldButton(text: 'ถัดไป', onPressed: _onNameNext, isLoading: _isLoading),
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
