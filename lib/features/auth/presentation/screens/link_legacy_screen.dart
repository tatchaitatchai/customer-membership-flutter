import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/gold_button.dart';
import '../../../../common/widgets/premium_card.dart';
import '../../data/auth_api.dart';

/// Self-service screen to link a legacy `members` row (from the old POS
/// system) to the current app user. Uses membership_number (preferred) or
/// legacy name + auto-matched last4.
class LinkLegacyScreen extends ConsumerStatefulWidget {
  const LinkLegacyScreen({super.key});

  @override
  ConsumerState<LinkLegacyScreen> createState() => _LinkLegacyScreenState();
}

class _LinkLegacyScreenState extends ConsumerState<LinkLegacyScreen> {
  final _membershipNumberCtrl = TextEditingController();
  final _legacyNameCtrl = TextEditingController();
  bool _isLoading = false;

  LinkLegacyResult? _lastResult;
  int? _linkedPoints;

  @override
  void dispose() {
    _membershipNumberCtrl.dispose();
    _legacyNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final mn = _membershipNumberCtrl.text.trim();
    final name = _legacyNameCtrl.text.trim();
    if (mn.isEmpty && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกหมายเลขสมาชิก หรือชื่อเก่า')));
      return;
    }
    setState(() => _isLoading = true);
    final res = await ref
        .read(authApiProvider)
        .linkLegacy(membershipNumber: mn.isEmpty ? null : mn, legacyName: name.isEmpty ? null : name);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!res.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error ?? 'เชื่อมบัญชีไม่สำเร็จ')));
      return;
    }
    _handleResult(res.data!);
  }

  Future<void> _chooseCandidate(int customerId) async {
    setState(() => _isLoading = true);
    final res = await ref.read(authApiProvider).confirmLinkLegacy(customerId);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (!res.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error ?? 'เชื่อมไม่สำเร็จ')));
      return;
    }
    _handleResult(res.data!);
  }

  void _handleResult(LinkLegacyResult r) {
    setState(() {
      _lastResult = r;
      if (r.status == 'LINKED') _linkedPoints = r.totalPoints;
    });
    if (r.status == 'NOT_FOUND') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(r.message ?? 'ไม่พบข้อมูลสมาชิกเดิม')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PointsMeTheme.darkBg,
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('เชื่อมบัญชีสมาชิกเดิม')),
      body: Container(
        decoration: const BoxDecoration(gradient: PointsMeTheme.darkGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_lastResult?.status == 'LINKED')
                  _buildLinkedCard(_linkedPoints ?? 0)
                else ...[
                  const Text(
                    'เคยเป็นสมาชิกร้านอยู่แล้ว?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'กรอกหมายเลขสมาชิก หรือชื่อที่เคยให้ไว้ ระบบจะเช็คกับเบอร์โทรของคุณให้อัตโนมัติ',
                    style: TextStyle(fontSize: 13, color: PointsMeTheme.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _membershipNumberCtrl,
                    style: const TextStyle(color: PointsMeTheme.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'หมายเลขสมาชิก (ถ้าจำได้)',
                      prefixIcon: Icon(Icons.badge_outlined, color: PointsMeTheme.primaryGold),
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _legacyNameCtrl,
                    style: const TextStyle(color: PointsMeTheme.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'ชื่อที่เคยให้ไว้กับร้าน',
                      prefixIcon: Icon(Icons.person_outline, color: PointsMeTheme.primaryGold),
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),
                  GoldButton(text: 'ค้นหา', onPressed: _submit, isLoading: _isLoading),
                ],

                if (_lastResult?.status == 'CANDIDATES') ...[
                  const SizedBox(height: 32),
                  const Text(
                    'พบข้อมูลที่ตรงกับหลายรายการ เลือกบัญชีของคุณ:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PointsMeTheme.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  for (final c in _lastResult!.candidates)
                    PremiumCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: PointsMeTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'last4: ${c.last4}${c.membershipNumber != null && c.membershipNumber!.isNotEmpty ? ' · #${c.membershipNumber}' : ''}',
                                  style: const TextStyle(fontSize: 12, color: PointsMeTheme.textSecondary),
                                ),
                                Text(
                                  'แต้มสะสม ${c.totalPoints}',
                                  style: const TextStyle(fontSize: 12, color: PointsMeTheme.primaryGold),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _isLoading ? null : () => _chooseCandidate(c.id),
                            child: const Text('เลือก', style: TextStyle(color: PointsMeTheme.primaryGold)),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLinkedCard(int points) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Icon(Icons.check_circle, size: 72, color: PointsMeTheme.primaryGold),
        const SizedBox(height: 16),
        const Text(
          'เชื่อมบัญชีสำเร็จ!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
        ),
        const SizedBox(height: 12),
        Text(
          'ประวัติและแต้ม $points คะแนน ถูกโอนเข้าบัญชีของคุณแล้ว',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: PointsMeTheme.textSecondary),
        ),
        const SizedBox(height: 40),
        GoldButton(text: 'เสร็จสิ้น', onPressed: () => context.pop()),
      ],
    );
  }
}
