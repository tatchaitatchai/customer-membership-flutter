import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/gold_button.dart';
import '../../../../common/widgets/premium_card.dart';
import '../../data/auth_api.dart';

/// Shown right after registration when the chosen store has one or more
/// legacy (unlinked) customer rows matching the user's phone last4.
/// User picks "this is me" (link legacy → preserve points) or "not me"
/// (create a fresh customers row at the store).
class MigrationDecisionScreen extends ConsumerStatefulWidget {
  final int storeId;
  final List<LinkableCustomerDto> candidates;

  const MigrationDecisionScreen({
    super.key,
    required this.storeId,
    required this.candidates,
  });

  @override
  ConsumerState<MigrationDecisionScreen> createState() => _MigrationDecisionScreenState();
}

class _MigrationDecisionScreenState extends ConsumerState<MigrationDecisionScreen> {
  int? _selectedId;
  bool _loading = false;

  Future<void> _onLinkSelected() async {
    if (_selectedId == null) return;
    setState(() => _loading = true);
    final res = await ref.read(authApiProvider).confirmLinkLegacy(_selectedId!);
    if (!mounted) return;
    setState(() => _loading = false);
    if (!res.isSuccess || res.data?.status != 'LINKED') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error ?? res.data?.message ?? 'เชื่อมบัญชีไม่สำเร็จ')),
      );
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('เชื่อมบัญชีเดิมสำเร็จ')),
    );
    context.go('/home');
  }

  Future<void> _onCreateNew() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PointsMeTheme.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('สร้างบัญชีใหม่', style: TextStyle(color: PointsMeTheme.textPrimary)),
        content: const Text(
          'ยืนยันว่าไม่ใช่เจ้าของบัญชีเดิม? ระบบจะสร้างบัญชีใหม่ที่ร้านนี้ โดยไม่มีแต้มสะสมเดิม',
          style: TextStyle(color: PointsMeTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('ยกเลิก', style: TextStyle(color: PointsMeTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('ยืนยัน', style: TextStyle(color: PointsMeTheme.primaryGold)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _loading = true);
    final res = await ref.read(authApiProvider).createStoreCustomer(widget.storeId);
    if (!mounted) return;
    setState(() => _loading = false);
    if (!res.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.error ?? 'สร้างบัญชีไม่สำเร็จ')),
      );
      return;
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PointsMeTheme.darkBg,
      body: Container(
        decoration: const BoxDecoration(gradient: PointsMeTheme.darkGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PointsMeTheme.primaryGold.withOpacity(0.15),
                      ),
                      child: const Icon(Icons.history, color: PointsMeTheme.primaryGold),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'เราเจอบัญชีที่อาจเป็นของคุณ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: PointsMeTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'ที่ร้านนี้มีบัญชีลูกค้าเดิมที่ 4 ตัวท้ายของเบอร์ตรงกับคุณ '
                  'หากเป็นของคุณ เลือกแล้วกด "นี่คือฉัน" เพื่อรับแต้ม/ประวัติเดิมไว้',
                  style: TextStyle(fontSize: 13, color: PointsMeTheme.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.candidates.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final c = widget.candidates[i];
                      final selected = c.id == _selectedId;
                      return PremiumCard(
                        padding: EdgeInsets.zero,
                        child: InkWell(
                          onTap: _loading ? null : () => setState(() => _selectedId = c.id),
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.name.isEmpty ? '(ไม่มีชื่อ)' : c.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: PointsMeTheme.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        [
                                          if ((c.membershipNumber ?? '').isNotEmpty) 'รหัส ${c.membershipNumber}',
                                          'เบอร์ลงท้าย ${c.last4}',
                                          '${c.totalPoints} แต้ม',
                                        ].join(' • '),
                                        style: TextStyle(fontSize: 12, color: PointsMeTheme.textSecondary),
                                      ),
                                    ],
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
                const SizedBox(height: 12),
                GoldButton(
                  text: 'นี่คือฉัน เชื่อมบัญชีเดิม',
                  onPressed: _selectedId == null ? null : _onLinkSelected,
                  isLoading: _loading,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _loading ? null : _onCreateNew,
                  child: const Text(
                    'ไม่ใช่ฉัน สร้างบัญชีใหม่',
                    style: TextStyle(color: PointsMeTheme.textSecondary),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
